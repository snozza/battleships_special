Battleship Special - Web Version
=================================

## Battleship - Web Version

### Introduction

Battleship was a group project in weeks 2 and 3 of Makers Academy. After this period, I decided to continue the project, using a large amount of the code from the group project, and adding to it in order to make an online multiplayer version. It is a very simple ruby/sinatra app that involves multiple routes which control the status of the game. While the game works, and can support multiple two player games at the same time, it lacks features such as dynamic updating (should essentially be a single page app).


### Languages/Platforms/Tools

* Sinatra
* Ruby
* Rspec
* Capybara
* Heroku

### Learning Outcomes

The aim was to make a mutiplayer Battleship game which would add in the learning or route handling and becoming familiar with Sinatra, a lightweight ruby framework. Without using JavaScript, JQuery, and related tools, it was difficult to make a seamless game experience (the pages are static and rely on refresh to serve updated content). I am however quite please with the end result, and I was able to learn the ins-and-outs of sinatra, while making a fully functionaly and largely bug-free session based online game.


### To-do List
- [ ] Fix bug that causes game to crash if person is playing in the one browser (session bug).
- [ ] CSS and HTML leave a lot to be desired. Positioning is ok, but the design is lackluster.
- [ ] Utilise javascript or similar to make the game more seamless (perhaps single page)
- [ ] Database integration with user accounts and/or scoreboards
- [ ] Definitely need to refactor. First attempt at building something with a ruby framework.

### Instructions

The live version of the site is available at [http://sea-questdsv.herokuapp.com/](http://sea-questdsv.herokuapp.com/).

Clone the repository:

```
$ git clone git@github.com:snozza/battleships_special.git
```

Change into the directory and bundle install the gems:

```
$ cd battleships_special
$ bundle install
```

Run the tests: 

```
$ rspec
```

Start the rack server and visit http://localhost/ on your local port 

```
$ ruby lib/battleships.rb (or use rackup)

### Gameplay Instructions

Please ensure that the game is played in two completely separate browsers (either different computers, or an incognito window in combination with a normal window). If you don't do this, the game will likely crash (current bug with two people playing on the same session).

The game rules are the same as normal battleship - choose a coordinate and shoot. The first person to sink all the other player's ships wins!
