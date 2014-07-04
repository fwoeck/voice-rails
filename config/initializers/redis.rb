$redis = ConnectionPool::Wrapper.new(size: 5, timeout: 3) {
  Redis.new(host: WimConfig.redis_host, port: WimConfig.redis_port, db: WimConfig.redis_db)
}
