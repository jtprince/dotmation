## dotmation

Github aware manager for environment files (e.g. dotfiles) inspired by fresh.
It has far fewer features than fresh and is written in ruby (taken together it
means it *may* be easier to extend).

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
<user>/dotfiles/config/dotmation/config)

    dotmation update --config jtprince

### Configuration

A dotmation config file is pure ruby code, so anything you can do in ruby you
can do in your config file.  The code will be read in context of
Dotmation::Reader and dir commands are also in context of the directory you
specify.

```ruby

repo_cache "~/dotrepos"                  # where to put all these files

github "jtprince/dotfiles/config" do      # stored in ~/dotrepos/jtprince/dotfiles
  dot 'Xresources'               # symlink ~/.Xresources
  dot 'Xresources', '.Xdefaults' # symlink ~/.Xdefaults -> Xresources
  dot 'zsh/zshenv'               # symlink ~/.zshenv

  xdg 'dunstrc'                  # symlink ~/.config/dunstrc
  xdg 'zsh'                      # symlink ~/.config/zsh
  xdg 'i3/config', 'i3/'         # symlink ~/.config/i3/config
end

github "jtprince/dotfiles/bin" do
  ln ".", "~/bin"
end

github "robbyrussel/oh-my-zsh" do
  xdg .                            # symlink ~/.config/oh-my-zsh
end

```

Note that a trailing slash may be important so it is understood that the file
is to go under the given directory.  Otherwise, it will clobber the directory.

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

Add bitbucket support.

## Copying

MIT license
