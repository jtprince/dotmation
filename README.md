## dotmation

Github aware manager for environment files (e.g. dotfiles) inspired by fresh.
It has far fewer features than fresh and is written in ruby (taken together it
means it *may* be easier to extend).

This is *alpha* software -- use at your own risk!

Features
* depends on ruby
* ruby dsl config file
* not yet as full featured as fresh but easy to customize if you write ruby

## Installation

    gem install dotmation

### Usage

Assuming your dotmation file resides or is linked where expected
(~/.config/dotmation/config), then usage is trivial:

    dotmation update

The first time you run dotmation, you will need to give it the filename or URI
to your dotmation file, or a github username (assuming it is in
<user>/dotfiles/master/config/dotmation/config)

    dotmation update --config your_github_username
    # --OR--
    dotmation update --config path/to/your/dotmation/config
    # --OR--
    dotmation update --config https://url/to/your/dotmation/config

### Configuration

A dotmation config file is pure ruby code, so anything you can do in ruby you
can do in your config file.  
```ruby

repo_cache "~/dotrepos"            # where to stash github repos

github "jtprince/dotfiles/config" do  
  cfg 'dotmation'                  # symlink ~/.config/dotmation directory

  dot 'Xresources'                 # symlink ~/.Xresources
  dot 'Xresources', '.Xdefaults'   # symlink ~/.Xdefaults -> Xresources

  dot 'zsh/zshenv', '.zshenv'      # symlink ~/.zshenv
  cfg 'zsh'                        # symlink ~/.config/zsh directory

  cfg 'dunstrc'                    # symlink ~/.config/dunstrc
  cfg 'i3/config', 'i3/'           # symlink ~/.config/i3/config inside i3 dir

  # Trailing slash -> the file is to go under the given directory.
end

github "jtprince/dotfiles/bin" do
  ln '.'
end

github "robbyrussell/oh-my-zsh" do
  cfg '.'                          # symlink ~/.config/oh-my-zsh
end

```

See a [real world example](https://github.com/jtprince/dotfiles/blob/master/config/dotmation/config).

The config file will be read in context of Dotmation::ConfigReader which is
responsible for creating repo objects and populating them with link objects.
All objects are created before being used to make links, so they can be easily
inspected.

## Bootstrap an Installation

There are several chicken and egg problems with setting up an evironment
without an environment.  This shell script initializes an environment to work
with dotmation(for debian systems).

    bash -c `curl -sL https://raw.github.com/jtprince/dotmation/master/script/bootstrap-ruby-env.sh`

This will install:

* rbenv
* ruby-build
* critical deb packages for building:
    * git curl zlib1g-dev build-essential libssl-dev libreadline-dev
* the latest stable ruby
* dotmation

Beware, it will write to (or create) ~/.profile, remove .bash_profile, and
write to ~/.bashrc.  Of course, all of these changes will be clobbered with
your own fresh symlinks (assuming you use these files) once you run dotmation
update.  The bootstrap supports the bash shell only (but you're smart enough
to drop down to bash to run the initial update if you're using a different
shell)

## todo

* Add bitbucket support.
* work out kinks with more complicated destinations
* use git@github instead of https:// for read/write access

## Copying

MIT license
