#Create telegraf 'http_respond' configuration file
sudo telegraf --input-filter http_response --output-filter influxdb config > http_response_telegraf.conf

#Delete the 'http_response' section
line=$(awk '/method and a timeout/{print NR}' http_response_telegraf.conf)
sed -i $line,'$d' http_response_telegraf.conf

#Append to the configuration file a new 'http_response' section
cat<<EOF >>http_response_telegraf.conf

# # HTTP/HTTPS request given an address a method and a timeout
  [[inputs.http_response]]
	name_override = "teridion"
	interval ="5s"
#   ## Server address (default http://localhost)
    address = "http://www.teridion.com"
#
#   ## Set http_proxy (telegraf uses the system wide proxy settings if it's is not set)
#   # http_proxy = "http://localhost:8888"
#
#   ## Set response_timeout (default 5 seconds)
    response_timeout = "5s"
#
#   ## HTTP Request Method
    method = "GET"
#
#   ## Whether to follow redirects from the server (defaults to false)
    follow_redirects = false
#
#   ## Optional HTTP Request Body
#   # body = '''
#   # {'fake':'data'}
#   # '''
#
#   ## Optional substring or regex match in body of the response
#   # response_string_match = "\"service_status\": \"up\""
#   # response_string_match = "ok"
#   # response_string_match = "\".*_status\".?:.?\"up\""
#
#   ## Optional TLS Config
#   # tls_ca = "/etc/telegraf/ca.pem"
#   # tls_cert = "/etc/telegraf/cert.pem"
#   # tls_key = "/etc/telegraf/key.pem"
#   ## Use TLS but skip chain & host verification
#   # insecure_skip_verify = false
#
#   ## HTTP Request Headers (all values must be strings)
#   # [inputs.http_response.headers]
#   #   Host = "github.com"

EOF

#Move the configuration file under 'telegraf.d' directory
sudo mv ./http_response_telegraf.conf /etc/telegraf/telegraf.d

#Restart the telegraf service
sudo systemctl restart telegraf
