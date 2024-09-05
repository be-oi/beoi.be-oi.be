FROM ruby:2.7.2

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .


CMD ["bundle", "exec", "middleman", "server"]
