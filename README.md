# Prerequisites

You need a remote Git repository for publishing. It's easiest if you use GitHub. So you'll need:

* a GitHub account
* an empty GitHub repository
* the URL to access the repository, obtainable from GitHub; typically of the form `git@github.com:USERNAME/REPOSITORY.git`

Prepared with the URL, you can bootstrap your project in a minute.

# Usage

**Requires ruby 2.0 or newer.**

You can use the installation script to set up a [nanoc](http://nanoc.ws/)-based wiki that publishes to GitHub Pages on your computer in no time.

## Option 1: Interactive (recommended)

Execute this command in your Terminal and follow the instructions:

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Weltenbastler/install/master/install_wiki.rb)"

This will create an empty project and push dummy contents to your repository and its `gh-pages` branch.

## Option 2: Download first

[Download the script](https://raw.githubusercontent.com/Weltenbastler/install/master/install_wiki.rb) and execute it like so:

    ruby install_wiki.rb <Git remote address> <path>
  
* **Git remote address**: an empty GitHub repository where you are going to host the wiki. 
* **path**: the path in your file system where you want to store the files. Can be `~/Documents/PROJECTNAME` or similar.

The result will be the same :)

# What then?

The script will tell you where to go from there. When the empty nanoc wiki is initialized, you can `cd` into the project directory and edit text files in the `content/` subfolder. 

## Start a local server

You can show the page as if it was online using `nanoc view`. This will start a simple webserver on your machine. Head to <http://localhost:3000/> once it started up successfully.

This is not necessary to make a HTML website from your files, but it'll help find problems.

**Note:** this command will run in your Terminal until you exit with Ctrl-C, so you cannot type anything yourself while it runs. Start it with a trailing `&` to move it into background mode: `nanoc view &`. Alternatively, use another shell session for this process (recommended).

## Compile HTML

You can compile a **local preview** using `nanoc compile`. The result will be in the project's `output/` folder.

While the server runs, you can run `nanoc compile` to update the contents without worrying.

## Publish
 
When you're satisfied, commit your changes locally:

    git add .
    git commit -m "<describe your changes here>"
    
You can upload them with `git push origin master` if you want.

To publish the website, run `rake publish`.
