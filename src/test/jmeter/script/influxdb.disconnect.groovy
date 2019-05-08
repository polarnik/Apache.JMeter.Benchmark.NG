import org.influxdb.InfluxDB;

InfluxDB influxDB;

influxDB = (InfluxDB)props.get("influxDB");

if (influxDB != null) {
    influxDB.close();
}

