# Codgen [![Gem Version](https://badge.fury.io/rb/codgen.svg)](http://badge.fury.io/rb/codgen) [![Build Status](https://travis-ci.org/beattyml1/codgen.svg)](https://travis-ci.org/beattyml1/codgen) [![Code Climate](https://codeclimate.com/github/beattyml1/codgen/badges/gpa.svg)](https://codeclimate.com/github/beattyml1/codgen)

Codgen is a cross language, template based, code generator, capable of generating multiple applications from a common model.

It uses JSON for it's model and config and you can use mustache or handlebars templates or just verbatim copy. 

If you find bugs or bad error messages be sure to log an issue. If it's not to big I'll probably get to pretty quickly. Pull requests are also most welcome!




## Installation

    $ gem install codgen

## Usage

    $ codgen.rb [input_directory_path|config_path.json] [output_directory_path]

Examples

    $ codgen.rb codgen_config.json
    $ codgen.rb input_dir output_dir
    
For more info see the wiki page

## Contributing

1. Fork it ( https://github.com/[my-github-username]/codgen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
