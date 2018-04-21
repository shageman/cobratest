# cobratest [![Build Status](https://travis-ci.org/shageman/cobratest.svg?branch=master)](https://travis-ci.org/shageman/cobratest) [![Gem Version](https://badge.fury.io/rb/cobratest.svg)](http://badge.fury.io/rb/cobratest) [![Code Climate](https://codeclimate.com/github/shageman/cobratest.png)](https://codeclimate.com/github/shageman/cobratest) [![Dependency Status](https://gemnasium.com/shageman/cobratest.svg)](https://gemnasium.com/shageman/cobratest)

Prints a list of the components that have changed since the last commit and for which tests need to be run. Uses the dependencies within component-based Ruby/Rails applications (#cbra) to also print all transitively affected components.

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
        -t, --test-runner RUNNER         Choose a test runner
        -v, --verbose                    Verbose output of all parts of the calculation
        -s, --since BRANCH               Specify BRANCH target to calculate against

## Example

There are sample #cbra folder structures in `spec/examples`. Here is an example run when changing a file in component `C`:

    $ bin/cobratest ./cobratest/spec/examples/letters/A
    ./cobratest/spec/examples/letters/B/test.sh
    ./cobratest/spec/examples/letters/C/test.sh
    ./cobratest/spec/examples/letters/A/test.sh

This output can be used to run the necessary tests like so:

    bin/cobratest ./cobratest/spec/examples/letters/A | xargs -n1 /bin/bash

You can choose a different test runner like so:

    $ bin/cobratest --test-runner 'myrunner --option 1' ./cobratest/spec/examples/letters/A
    ./cobratest/spec/examples/letters/B/myrunner --option 1
    ./cobratest/spec/examples/letters/C/myrunner --option 1
    ./cobratest/spec/examples/letters/A/myrunner --option 1

In verbose mode one can check the correctness of cobratest's calculation:

    $ bin/cobratest -v ./cobra/cobratest/spec/examples/letters/A
    All components
    B    ./cobra/cobratest/spec/examples/letters/B
    C    ./cobra/cobratest/spec/examples/letters/C
    D    ./cobra/cobratest/spec/examples/letters/D
    E1   ./cobra/cobratest/spec/examples/letters/E1
    E2   ./cobra/cobratest/spec/examples/letters/E2
    F    ./cobra/cobratest/spec/examples/letters/F
    A    ./cobra/cobratest/spec/examples/letters/A

    Changes since last commit
    ./cobra/cobratest/README.md
    ./cobra/cobratest/spec/examples/letters/C/Gemfile

    Directly affected components
    C    ./cobra/cobratest/spec/examples/letters/C

    Transitively affected components
    B    ./cobra/cobratest/spec/examples/letters/B
    C    ./cobra/cobratest/spec/examples/letters/C
    A    ./cobra/cobratest/spec/examples/letters/A

    Test scripts to run
    ./cobra/cobratest/spec/examples/letters/B/test.sh
    ./cobra/cobratest/spec/examples/letters/C/test.sh
    ./cobra/cobratest/spec/examples/letters/A/test.sh

## Todos
* make algorithm work for structures where a gem is in a sub folder of another gem (only the inner gem should be directly affected)
* allow for other test runners to be specified

## License

Copyright (c) 2014 Stephan Hagemann, stephan.hagemann@gmail.com, [@shageman](http://twitter.com/shageman)

Released under the MIT license. See LICENSE file for details.
