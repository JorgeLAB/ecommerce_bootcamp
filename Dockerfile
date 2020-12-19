FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt-get update && apt-get install -y build-essential libsqlite3-dev sqlite3 
WORKDIR /bootcamp9
COPY Gemfile /bootcamp9/Gemfile
COPY Gemfile.lock /bootcamp9/Gemfile.lock
RUN bundle install
COPY . /bootcamp9

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]