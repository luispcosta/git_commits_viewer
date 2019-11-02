# Git commit viewer

This project allows you to see the list of commits given a github repository URL, for a given branch inside that repository.
By default, it is assumed that one wants to show the commits for the `master` branch, but you can specify a different branch.

The github url provided MUST respect the following format:

`git://github.com/_owner_/_reponame_.git`

Any other URL format will not be accepted. We only accept urls using the `git` protocol to avoid the need to provide a username and password when requesting the repository information.

## Requirements

In order to run this program, you need the following software installed in your machine:

* [git](https://git-scm.com/) (at least 2.21.0)
* [ruby](http://www.ruby-lang.org/en/) (at least 2.6.3)
* [ruby gems](https://rubygems.org/) (at least 3.0.4)
* [bundler](https://bundler.io/) (at least 1.17.3)
* [perl](https://www.perl.org/) (at least v5.28.2)

## Installation

After verifying that you have all the required software installed in your machine, `cd` into the directory where you have downloaded the project to.

```
bundle install
```

## Usage

There are two modes of usage: using the `cli` script or running a local `api`.


### CLI mode

You can invoke the `cli` script to list the commits of a repository in your command line.

Example:

```
ruby cli.rb --url=git://github.com/rails/rails.git
# {"commit"=>"236e20e6fbde5f980e2169dcc99e42d29f43589d", "author"=>"jonathankwok <jonathan.kwok@shopify.com>", "date"=>"Tue Oct 15 15:18:07 2019 -0400", "message"=>"Don-t-add-new-lookup-replace-existing-one-instead"}
# {"commit"=>"41bbd7cd0e4e950ea5a366f78b26b32ed6bd0644", "author"=>"Gannon McGibbon <gannon.mcgibbon@gmail.com>", "date"=>"Tue Oct 15 13:15:39 2019 -0400", "message"=>"Merge-pull-request-37429-from-gmcgibbon-opt_into_has_many_inverse"}
# {"commit"=>"be3d9daaa39aa69603af16b602fe62ae47548469", "author"=>"Richard Schneeman <richard.schneeman+foo@gmail.com>", "date"=>"Tue Oct 15 08:08:36 2019 -0500", "message"=>"Merge-pull-request-37478-from-martinbjeldbak-update-documentation-link"}
# {"commit"=>"e8a881a753c5b8f029924e1b79229540f8908714", "author"=>"Martin Bjeldbak Madsen <me@martinbjeldbak.com>", "date"=>"Tue Oct 15 22:31:24 2019 +1000", "message"=>"Add-two-cross-links-to-methods-in-docs-skip-ci"}
```

If you wish to view the commits of a different branch:

```
ruby cli.rb --url=git://github.com/rails/rails.git --branch=1-2-stable
# {"commit"=>"5b3f7563ae1b4a7160fda7fe34240d40c5777dcd", "author"=>"Jeremy Kemper <jeremy@bitsweat.net>", "date"=>"Tue Feb 19 02:09:55 2008 +0000", "message"=>"Remove-wasteful-signal-trap-from-transactions.-Backport-from-2-0-stable"}
# {"commit"=>"f756bfbe89da504729a1e59d1cbfc4044257057d", "author"=>"Jeremy Kemper <jeremy@bitsweat.net>", "date"=>"Sat Feb 2 05:37:22 2008 +0000", "message"=>"Merge-r8782-from-trunk-TestSession-supports-indifferent-access.-References-7372"}
```

To view the list of options and the explanation of what each option represents, please run

```
ruby cli.rb --help
``` 

### API mode

```
ruby api.rb
```

By default, this will run an HTTP server in the port `4567`. This api responds to a single endpoint:

``` 
localhost:4567/commits?url=_url_&page=_page_&per_page=_per_page_&branch=_branch_
```

The restrictions on the query params are the same as the restrictions for the CLI options.

If you wish to run the API on a different port, please run (subtitute PORT with a port number of your prefference):


```
ruby api.rb PORT
```