web: rails s -p 3000 -b 0.0.0.0
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
js: yarn build:js --watch
css: yarn build:css --watch
minio: mkdir -p tmp/minio && minio server tmp/minio --console-address :9090
imgproxy: imgproxy
meilisearch: meilisearch --log-level=ERROR --db-path tmp/meilisearch
# ws: ANYCABLE_TURBO_RAILS_KEY="def" ANYCABLE_DISABLE_DISCONNECT=1 ANYCABLE_JWT_ID_KEY="abc" anycable-go --port=8080 --debug --broadcast_adapter=http