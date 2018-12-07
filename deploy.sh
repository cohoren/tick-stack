
BGREEN='\033[1;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

write_message(){
  case $1 in
        RED)
          echo -e "${RED}$2${NC}";;
        YELLOW)
          echo -e "${YELLOW}$2${NC}";;
        GREEN)
          echo -e "${GREEN}$2${NC}";;
        BGREEN)
          echo -e "${BGREEN}$2${NC}";;
  esac
}

read -p "Starting to install the Tick monitoring Stack? Y/N " -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
     write_message RED "\nOperation Canceled!"
     exit 0
fi

check_service_status(){
	wait ${!}
	sleep 10
        systemctl status $1 | grep 'Active: active (running)' &> /dev/null
	if [ $? == 0 ]; then
	  write_message GREEN "Service '$1' is up!"
	else
	  write_message RED "Service '$1' is down!"
	  systemctl status $1 
	  exit 1
	fi
}

write_message YELLOW "\n\n******************************************"
write_message YELLOW "*** Installing and Configuring InfluxDB***"
write_message YELLOW "******************************************"
write_message YELLOW ""

write_message YELLOW "Adding the InfluxData repository"
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

write_message YELLOW "Updating the package list"
sudo apt-get update

write_message YELLOW "Installing InfluxDB"
sudo apt-get install -y influxdb

write_message YELLOW "Starting the InfluxDB service"
sudo systemctl start influxdb
write_message GREEN "OK"

write_message YELLOW "Verifying the service status"
check_service_status influxdb

write_message YELLOW "Creating a new admin user for InfluxDB"
curl "http://localhost:8086/query" --data-urlencode "q=CREATE USER inf_admin WITH PASSWORD 'inf_admin' WITH ALL PRIVILEGES"

write_message YELLOW "Setting 'auth-enabled=true'"
sudo sed -i -e 's/# auth-enabled = false/ auth-enabled = true/g' /etc/influxdb/influxdb.conf
write_message GREEN "OK"

write_message YELLOW "Restarting the InfluxDB service"
sudo systemctl restart influxdb
write_message GREEN "OK"

write_message YELLOW "Verifying the service status"
check_service_status influxdb


write_message YELLOW "******************************************"
write_message YELLOW "*** Installing and Configuring Telegraf***"
write_message YELLOW "******************************************"
write_message YELLOW ""

write_message YELLOW "Installing Telegraf"
sudo apt-get install -y telegraf
check_service_status telegraf

write_message YELLOW "Configuring influxDB Username & Password"
sudo sed -i -e 's/# username = "telegraf"/ username = "inf_admin"/g' /etc/telegraf/telegraf.conf
sudo sed -i -e 's/# password = "metricsmetricsmetricsmetrics"/ password = "inf_admin"/g' /etc/telegraf/telegraf.conf

write_message YELLOW "Restarting Telegraf Service"
sudo systemctl restart telegraf
write_message GREEN "OK"

write_message YELLOW "Verifying the service status"
check_service_status telegraf

write_message YELLOW "*************************************"
write_message YELLOW "Installing and Configuring Kapacitor"
write_message YELLOW "*************************************"
write_message YELLOW ""

write_message YELLOW "Installing Kapacitor"
sudo apt-get install -y kapacitor

write_message YELLOW "Configuring Kapacitor Username & Password"
sudo sed -i -e 's/username = ""/ username = "inf_admin"/g' /etc/kapacitor/kapacitor.conf
sudo sed -i -e 's/password = ""/ password = "inf_admin"/g' /etc/kapacitor/kapacitor.conf

write_message YELLOW "Starting Kapacitor Service"
sudo systemctl start kapacitor
write_message GREEN "OK"

write_message YELLOW "Verifying the service status"
check_service_status kapacitor

write_message YELLOW "*************************************"
write_message YELLOW "Installing and Configuring Chronograf"
write_message YELLOW "*************************************"
write_message YELLOW ""

write_message YELLOW "Installing Chronograf"
wget https://dl.influxdata.com/chronograf/releases/chronograf_1.2.0~beta5_amd64.deb
sudo dpkg -i chronograf_1.2.0~beta5_amd64.deb

write_message YELLOW "Starting the Chronograf service"
sudo systemctl start chronograf
write_message GREEN "OK"

write_message YELLOW "Verifying the service status"
check_service_status chronograf

write_message BGREEN "\n***** Tick stack has been installed successfuly! *****\n"
write_message YELLOW "\nBrowse to ${BGREEN}http://localhost:8888$ {YELLOW}and login to Chronograf dashboard"
write_message YELLOW "\nLogin Credentials:\n${GREEN}Username:${RED}inf_admin${GREEN}\nPassword:${RED}inf_admin\n"
write_message YELLOW "\nPlease, read the ReadMe.md file for more insructions about Chronograf\n"
write_message YELLOW "https://github.com/cohoren/tick-stack/blob/master/README.md\n"
