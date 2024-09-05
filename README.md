# beoi.be-oi.be - Static website

Using [Middleman](https://middlemanapp.com/) for static website generator.

## Contributing

Prerequisite: Ruby and bundler

In the project directory, install required package: 

    bundle install

Launch the (auto-reload) web server: 

    bundle exec middleman server

Install [EditorConfig](http://editorconfig.org/) for your favorite editor to enforce the formatting rules of source files.

## Build and Deployment

To build:

    bundle exec middleman build

To deploy on S3 (requires AWS credentials in `.s3.sync` in the yaml format):

    bundle exec middleman s3_sync

## Using Docker

Install Docker.

```
docker build . -t beoiwebsite
docker run -it -p 4567:4567 --mount type=bind,source="$(pwd)",target=/usr/src/app beoiwebsite
```
