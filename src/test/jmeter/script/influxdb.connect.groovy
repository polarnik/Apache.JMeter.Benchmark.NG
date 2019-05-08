import org.influxdb.InfluxDB;
import org.influxdb.InfluxDBFactory;
import org.influxdb.BatchOptions;

String influxdb_host;
String influxdb_port;
String influxdb_database;
String influxdb_username;
String influxdb_password;
InfluxDB influxDB;

influxdb_host = vars.get("influxdb.host");
influxdb_port = vars.get("influxdb.port");
influxdb_database = vars.get("influxdb.database");
influxdb_username = vars.get("influxdb.username");
influxdb_password = vars.get("influxdb.password");

String influxdb_url = "http://" + influxdb_host + ":" + influxdb_port;

influxDB = InfluxDBFactory.connect(influxdb_url,
        influxdb_username, influxdb_password);
influxDB.setDatabase(influxdb_database);
influxDB.enableBatch(BatchOptions.DEFAULTS);

props.put("influxDB", influxDB);