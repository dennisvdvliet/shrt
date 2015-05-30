# shrt

A simple url shortner using Rails and sqlite

## Setup
```
bundle install
rake db:setup
mv Procfile.dev.example Procfile.dev
```

## Running
```
foreman start -f Procfile.dev
```

## Running test
```
bundle exec rspec
```

## Usage

### Creating a new link

**Request**
```
curl -H "Content-Type: application/json" -X POST -d '{"url":"http://impraise.com"}' http://localhost:3000/shorten
```

**Response**
```json
{"shortcode":"ysyxDsa"}
```

### Getting a link
**Request**
```
curl http://localhost:3000/ysyxDsa
```

**Response**
Redirect to http://impraise.com

### Getting stats for a link

**Request**
```
curl -H "Content-Type: application/json" http://localhost:3000/ysyxDsa/stats
```

**Response**
```json
{
  "startDate": "2015-05-30T14:57:18.283Z",
  "lastSeenDate": "2015-05-30T14:57:18.283Z",
  "redirectCount": 3
}
```
