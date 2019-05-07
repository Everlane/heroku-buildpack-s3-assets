# s3-assets-buildpack

This buildpack runs at _compile_ time to (1) upload assets to S3 and (2) delete the assets.

## Rationale

Heroku recommends serving assets from Heroku, fronted by a caching CDN. That works great for most use-cases, but some application need to be able to serve those assets _in perpetuity_. This buildpack supports that use-case.
