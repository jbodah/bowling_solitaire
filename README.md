# Bowling Solitaire Simulator

## Overview

I was curious how often it's possible to bowl a strike in the card game [Bowling Solitaire](https://boardgamegeek.com/boardgame/25314/bowling-solitaire) so I wrote a simulator which randomly generates games and iterates the state tree to figure out whether or not a strike is possible.

## Running

```
./bin/simulate 1000

{:strikes=>0.743, :spares=>0.037, 0=>0.003, 1=>0.0, 2=>0.0, 3=>0.0, 4=>0.0, 5=>0.002, 6=>0.007, 7=>0.007, 8=>0.034, 9=>0.167}
```

Thus, if my math is correct, a perfect score over a 10-round game should be possible 5% of the time or 1 in 20 games
