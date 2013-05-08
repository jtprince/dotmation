## dotmation

Github aware manager for environment files (e.g. dotfiles) inspired by fresh.

* depends on ruby (pro/con)
* ruby dsl config file

## installation

### Bootstrap

For fresh environments, this will ensure you have a working rbenv ruby (deb
based systems only for now) and install the dotmation gem. (hint: you can
examine the script before running it if you're paranoid.)

    bash -c `curl https://raw.github.com/jtprince/dotmation/master/bootstrap.sh`

### Normal

If you already have a working ruby, just

    gem install dotmation

### Initial configuration - the chicken and egg

The first time you run dotmation, you will need to give it the filename or URI
to your dotmation file.  Alternatively, give it a github username, it will
look for <user>/dotfiles/config/dotmation/config 

    dotmation init jtprince

## example

### Usage

Assuming your dotmation file resides or is linked where expected
(~/.config/dotmation/config), then usage is trivial.

Usage:

    dotmation update

### Configuration

A dotmation config file is pure ruby code, so anything you can do in ruby you
can do in your config file.  The code will be read in context of
Dotmation::Reader and dir commands are also in context of the directory you
specify.

```ruby

repo "~/dotrepos"                  # where to put all these files

github "jtprince/dotfiles" do      # stored in ~/dotrepos/jtprince/dotfiles
  dir 'config' do
    dot 'Xresources'               # symlink ~/.Xresources
    dot 'Xresources', '.Xdefaults' # symlink ~/.Xdefaults -> Xresources
    dot 'zsh/zshenv'               # symlink ~/.zshenv

    xdg 'dunstrc'                  # symlink ~/.config/dunstrc
    xdg 'zsh'                      # symlink ~/.config/zsh
    xdg 'i3/config', 'i3/'         # symlink ~/.config/i3/config
  end
end

github "robbyrussel/oh-my-zsh" do
  xdg .                            # symlink ~/.config/oh-my-zsh
end

```

## todo

Add bitbucket support.

## Copying

MIT license
