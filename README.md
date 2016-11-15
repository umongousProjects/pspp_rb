# PsppRb

Wrapper for GNU PSPP https://www.gnu.org/software/pspp

Allows you to export data from plain Ruby-object to SPSS file format

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pspp_rb', github: 'umongousProjects/pspp_rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pspp_rb

You have to have GNU PSPP installed https://www.gnu.org/software/pspp.

## Usage

```ruby
# prepare data
variables = [PsppRb::Variable.new(name: 'VAR0', format: 'F4.1', level: 'ORDINAL', label: 'make const not var'),
             PsppRb::Variable.new(name: 'VAR1', format: 'A50', level: 'NOMINAL'),
             PsppRb::Variable.new(name: 'VAR2', format: 'F9.4'),
             PsppRb::Variable.new(name: 'VAR3', value_labels: { 1 => 'one', 2 => 'two' })]

dataset = PsppRb::DataSet.new(variables)

1.upto(15) do |i|
  values = [100 * i,
            'text' * i,
            200 * i,
            i % 2 + 1]
  cas = PsppRb::Case.new(values)
  dataset << cas
end

# export to a sav file
PsppRb.export(dataset, '/path/to/file.sav')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/umongousProjects/pspp_rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
