![Screenshot](tick_stack.png)

The ***Deploy.sh*** Script deploys the TICK stack components.<br />
The following projects Telegraf, InfluxDB, Kapacitor, Chronograf will be installed and will be configured together.

### Prerequisites

1. Linux Ubuntu OS
2. **Execute** permission for ***Deploy.sh*** file

### Installing TICK stack

Run ***Deploy.sh*** script on ubuntu machine and follow the messages during the running.<br />
At the end of the installation you can access the Chronograf UI through the browser.

### Login to Chronograf

Launch your browser and browse to http://localhost:8888<br />
Insert the following credentials and click on "**Connect New Source**" button:<br />
Username: **inf_admin**<br />
Password: **inf_admin**<br />
<br />![Screenshot](chronograf_login.png)<br />
Click on the hostname link<br />
![Screenshot](host_click.png)<br />
And you should get the metrics graphs<br />
![Screenshot](metrics_graph.png)<br />
## Author

* **Oren Cohen**

## References

* https://www.influxdata.com/time-series-platform/
