# logstash-filter-sentimentalizer

This is a plugin for [Logstash](https://github.com/elasticsearch/logstash).
[![Build Status](https://travis-ci.org/tylerjl/logstash-filter-sentimentalizer.svg?branch=master)](https://travis-ci.org/tylerjl/logstash-filter-sentimentalizer)
This plugin enables you to perform effective sentiment analysis on arbitrary event fields with pretty simple configuration.
Consider the following:

```
filter {
  sentimentalizer {
    source => "message"
  }
}
```

Is enough to perform sentiment analysis on the `message` field.

Results are stored in the `sentiment.probability` (a float between 0 and 1, 0 being wholly negative and 1 being maximum positive) and `sentiment.polarity` (an enum with the members "positive", "negative", and "neutral") fields of the processed event (these names come from the underlying sentiment analysis library).

Here's a short demo of it in action.

![logstash demo gif](./demo.gif)

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

Logstash provides infrastructure to automatically generate documentation for this plugin. We use the asciidoc format to write documentation so any comments in the source code will be first converted into asciidoc and then into html. All plugin documentation are placed under one [central location](http://www.elasticsearch.org/guide/en/logstash/current/).

- For formatting code or config example, you can use the asciidoc `[source,ruby]` directive
- For more asciidoc formatting tips, see the excellent reference here https://github.com/elasticsearch/docs#asciidoc-guide

## Need Help?

Need help? Try #logstash on freenode IRC or the logstash-users@googlegroups.com mailing list.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-filter-awesome", :path => "/your/local/logstash-filter-awesome"
```
- Install plugin
```sh
bin/plugin install --no-verify
```
- Run Logstash with your plugin
```sh
bin/logstash -e 'filter {awesome {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-awesome.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/plugin install /your/local/plugin/logstash-filter-awesome.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elasticsearch/logstash/blob/master/CONTRIBUTING.md) file.
