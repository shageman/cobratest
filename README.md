# cobratest [![Build Status](https://travis-ci.org/shageman/cobratest.svg?branch=master)](https://travis-ci.org/shageman/cobratest) [![Gem Version](https://badge.fury.io/rb/cobratest.svg)](http://badge.fury.io/rb/cobratest) [![Code Climate](https://codeclimate.com/github/shageman/cobratest.png)](https://codeclimate.com/github/shageman/cobratest) [![Dependency Status](https://gemnasium.com/shageman/cobratest.svg)](https://gemnasium.com/shageman/cobratest)

Prints a list of the components that have changed since the last commit and for which tests need to be run. Uses the dependencies within component-based Ruby/Rails applications (#cobra) to also print all transitively affected components.

## Installation

Add this line to your application's Gemfile:

    gem 'cobratest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cobratest

## Usage

    cobratest [OPTION] [application path]

    Test runner employing the structure of Component-based Ruby/Rails apps to optimize what needs to run.

    Options are...
        -h, -H, --help                   Display this help message.

        -r, --results                    DEFAULT Display the directories of the components in need of running tests
        -v, --verbose                    Verbose output of all parts of the calculation

## Example

There are sample #cobra folder structures in `spec/examples`. Here is an example run when changing a file in component `C`:

    ± |master ✗| → bin/cobratest ~/workspace/cobratest/spec/examples/letters/A
    /Users/stephan/workspace/cobratest/spec/examples/letters/B/test.sh
    /Users/stephan/workspace/cobratest/spec/examples/letters/C/test.sh
    /Users/stephan/workspace/cobratest/spec/examples/letters/A/test.sh

This output can be used to run the necessary tests like so:

    bin/cobratest ~/workspace/cobratest/spec/examples/letters/A | xargs -n1 /bin/bash

In verbose mode one can check the correctness of cobratest's calculation:

    ± |master ✗| → bin/cobratest -v ~/workspace/cobra/cobratest/spec/examples/letters/A
    All components
    B    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/B
    C    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/C
    D    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/D
    E1   /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/E1
    E2   /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/E2
    F    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/F
    A    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/A

    Changes since last commit
    /Users/stephan/workspace/cobra/cobratest/README.md
    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/C/Gemfile

    Directly affected components
    C    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/C

    Transitively affected components
    B    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/B
    C    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/C
    A    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/A

    Test scripts to run
    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/B/test.sh
    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/C/test.sh
    /Users/stephan/workspace/cobra/cobratest/spec/examples/letters/A/test.sh

## Todos
* make algorithm work for structures where a gem is in a sub folder of another gem (only the inner gem should be diectly affected)
* allow for other test runners to be specified
* optionally check for changes since origin/master
* optionally allow branch to compare against to be specified

## License

Copyright (c) 2014 Stephan Hagemann, stephan.hagemann@gmail.com, [@shageman](http://twitter.com/shageman)

Released under the MIT license. See LICENSE file for details.
