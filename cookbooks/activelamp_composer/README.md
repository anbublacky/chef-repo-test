[![Build Status](https://travis-ci.org/activelamp/composer-cookbook.png)](https://travis-ci.org/activelamp/composer-cookbook)

Description
===========

This cookbook provides an easy way to operate on Composer projects, like being able to install or update dependencies, as well as optimizing the autoloader.

Requirements
============

* `php`
* `curl`

This cookbook is not responsible for satisfying these requirements. You will have to provision your machine with these through your platform's dependency manager (`apt`, `yum`, etc), or through other cookbooks.

## Platforms:

* Tested on Ubuntu/Debian only, but the deploy actions should work with any platform.


Resources / Providers
=====================

### `composer`

#### Actions
  * `download_phar`
  * `install` (Default)
  * `update`
  * `dump_autoload`
  * `run_script`

#### Examples

###### Download `composer.phar` into your project root:

```ruby
composer "/path/to/project" do
    action :download_phar
end
```

###### Install dependencies

```ruby
composer "/path/to/project" do
    action :install
    prefer_dist true # Default
    prefer_source false # Default
end
```

if you want to ensure that installs should only be done with `composer.lock` present:

```ruby
composer "/path/to/project" do
    lock_file_only true
    action :install
end
```

###### Update dependencies
```ruby
composer "/path/to/project" do
    optimize_autoloader true # Default is 'false'
    action :update
end
```

###### Dump autoloader
```ruby
composer "/path/to/project" do
    optimize_autoloader true # Default is 'false'
    action :dump_autoload
end
```

###### Run Composer scripts
```ruby
composer "/path/to/project" do
    script 'post-install-cmd'
    action :run_script
end
```

Options
=======

Option | Default | Description
-------|---------|------------
__directory__ | the resource name | The path to the Composer project
__dev__       | `true` | If `false`, Composer commands are run with the `--no-dev` flag when applicable
__verbosity__ | `1`   | The verbosity level. Could be `1`, `2`, or `3`.
__quiet__     | `true` | Supress output with the `--quiet` flag
__prefer_dist__ | `false` | If `true`, runs commands with `--prefer-dist` when applicable
__prefer_source__ | `false` | If `true`, runs commands with `--prefer-source` when applicable
__optimize_autoloader__ | `false` | If `true`, runs commands with `--optimize-autoloader` or `--optimize` when applicable
__script__ | empty string | The script to run when called with the `:run_script` action.
__user__ | `nil` | The user responible for the command (Passed to the `execute` resource internally)
__group__ | `nil` | The group responible for the command (Passed to the `execute` resource internally)

License and Authors
===================

Author: Bez Hermoso <bez@activelamp.com>

Author: ActiveLAMP

Copyright: 2012-2014, ActiveLAMP

[Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html)
