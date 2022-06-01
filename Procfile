web: rails s -p 3000 -b 0.0.0.0
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
js: yarn build --watch
css: yarn build:css --watch
minio: mkdir -p tmp/minio && minio server tmp/minio --console-address :9090
imgproxy: imgproxy