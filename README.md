# Dlang Vibe.d demo for benchmark

## Overview

This is a simple Vibe.d demo that receives specific JSON and returns simple JSON response.

Request format:

```
{
    "id": <random_id>,
    "first_name": "John",
    "last_name": "Doe"
}
```

Response format:

```
{
    "id": <random_id>,
    "first_name": "John <md5 hash of 'John'>",
    "last_name": "Doe <md5 hash of 'Doe'>",
    "current_time": strftime("%F %T %z"),
    "say": "Dlang is the best"
}
```

## Used libraries

`libmir/asdf` for JSON parsing - it is expected that it would be faster than Vibe.d and Phobos implementations (just an assumption, not tested).

## Build

For DMD build:
```
dub build --build=release
```

For LDC:
```
dub build --build=release --compiler=ldc2
```
