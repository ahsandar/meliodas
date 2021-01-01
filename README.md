# Meliodas

![Image](/assets/static/images/dragon_sin.jpeg)

![Image](/assets/static/images/smart_display.png)



To start Meliodas, the hard way:

  * Install [speedtest cli] (https://www.speedtest.net/apps/cli)
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`


To start Meliodas the easy way:

> `MIX_ENV=<prod/dev> SPEEDTESTARCH=<x86_64/armhf> docker-compose build`

> `MIX_ENV=<prod/dev> SPEEDTESTARCH=<x86_64/armhf> docker-compose up`


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Special credit to these resources

* https://github.com/chrismccord/phoenix_live_view_example
* https://github.com/brennentsmith/internet-speed-logger
* https://www.kabisa.nl/tech/real-world-phoenix-of-groter-dan-a-liveview-dashboard/

## API credits
* https://apify.com/covid-19
* http://data.fixer.io/api/latest - require sign up
* https://www.dawn.com/feeds/home - rss feed
* wttr.in - json format used
* speedtest - cli app

Signup to `Sentry` and add `dsn` in config if required

If you get to use it please don't forget to add it to your credits. Thanks

![Image](/assets/static/images/seven_deadly_sins.jpeg)
