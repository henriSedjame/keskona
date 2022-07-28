class DBConfig {

  late final String host;
  late final int port;
  late final String database;
  late final String user;
  late final String password;

  DBConfig(this.host, this.port, this.database, this.user, this.password);

  factory DBConfig.fromJson(Map<String, dynamic> json) {
    return DBConfig(
      json["host"],
      json["port"],
      json["database"],
      json["user"],
      json["password"]
    );
  }

}