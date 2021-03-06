## SoundCloud Instant

[![Code Climate](https://codeclimate.com/github/infinitus/soundcloud-instant/badges/gpa.svg)](https://codeclimate.com/github/infinitus/soundcloud-instant)

An excuse to play with Sinatra and SoundCloud APIs. The site is up on [http://soundcloud.crypt.sg](http://soundcloud.crypt.sg).

## Build

```sh
# Clone the repo
git clone git@github.com:infinitus/soundcloud-instant.git && cd soundcloud-instant

# Install gems
bundle install

# Copy .env.sample as .env and fill it up with the relevant configuration.
# CLIENT => Your SoundCloud client API
# SECRET => SecureRandom.hex(64)
# DEFAULT_TRACK => The HTTP SoundCloud URL of your preferred default track.

# Start Redis (for session store)
redis-server

# Run the app with Thin
ruby app.rb
```

## License

MIT
