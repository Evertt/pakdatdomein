# pakdatdomein

This is a project for a fictional business / service, so that I could try out an event-sourcing architecture in my domain design.

This fictional service lets users buy and sell domain names, including ones that are not available yet, but have been found to become available soon.

So when the code finds a soon-to-be-available domain name, it automatically puts it up for sale for 99 dollars and then a user can immediately request to purchase it. The code then tries to grab the domain name as soon as it becomes available. If it succeeds, it will sell it to the user, otherwise it will cancel the sale.

The user, if it has become the new owner of the domain name, can then choose to sell it themself for any price, or put it on auction.

To understand what this looks like in code, I recommend looking at the files in [this folder](https://github.com/Evertt/pakdatdomein/tree/master/Sources/Model/Domain) and / or to look at the [testing code](https://github.com/Evertt/pakdatdomein/blob/master/Tests/ModelTests/ModelTests.swift).

Again, this was to experiment with the event-sourcing pattern, which you can read more about [here](https://martinfowler.com/eaaDev/EventSourcing.html).
