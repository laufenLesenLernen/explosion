# A simple Elm game

The file `explosion.elm` contains the skeleton for a simple game in Elm that I wrote an afternoon of learning Elm, in which a character walks around using the arrow keys, and tries to avoid "bombs" that are placed on the board. If the character comes too close to a bomb, an explosion animation might play. Currently, it prints to the screen the position of the character and the bombs, and the number of explosions that have occurred.

I like this code sample because it's readable, demonstrating the ease of use of Elm, while also demonstrating some of the intricacies and advantages of Haskell-like functional languages such as curried functions, recursion, and immutable data types. Additionally, it demonstrates how Elm naturally leads to good architecture decisions with the Model, Update, Subscription, View style.

### Further Development

I would like to add animation to this, as well as bombs randomly generating with an average of 15sec or so.

