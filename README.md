Battleship Special - Web Version
=================================

## Battleship - Web Version

### Introduction

Very simple ruby/sinatra app sans any JS. While the game works, and can support multiple two player games at the same time, it is lackluster and does not have any JavaScript etc....nothing is dynamic.


### Languages/Platforms/Tools

* Sinatra
* Ruby
* Rspec
* Capybara
* Heroku

### Learning Outcomes

Don't make games on a static website...and clean up your damn code!

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
