#! /bin/bash

###############################################################################
# Variable  Declaration
###############################################################################

WP_CONFIG_FILE=/var/www/html/wp-config.php
WP_PROPERTIES_FILE=/opt/wordpress.properties


###############################################################################
# Function Declaration
###############################################################################

# Write message to stdout and exit
function exit_error {
  echo "[`date`] ${*}"
  exit 1
}

# Write message to stdout
function console_msg {
  echo "[`date`] ${*}"
}


function get_wordpress_conf_properties {
  [[ -f ${WP_PROPERTIES_FILE} && -r ${WP_PROPERTIES_FILE} ]] || \
    exit_error "Error: ${WMIC_PROPERTIES} does not exist or does not have read permission"
  while read -r line
  do
    keyVal=(`echo $line | sed 's/=/ /'`)
    index=0
    while [ $index -lt ${#keyVal[@]} ]
    do
      if [ $index -eq 0 ]
      then
        propList[${keyVal[0]}]=''
      else
        propList[${keyVal[0]}]=`echo ${propList[${keyVal[0]}]} ${keyVal[$index]}`
      fi
      index=$[$index+1]
    done
  done < <(cat ${WMIC_PROPERTIES} | grep -v "^#")
}

function update_wordpress_database_details {  
    if [[ -f $WP_CONFIG_FILE && -w $WP_CONFIG_FILE ]]
    then
        sed -i -e "/DB_NAME/{s#database_name_here#${propList[DATABASE]}#g}" \
                -e "/DB_USER/{s#username_here#${propList[USER]}#g}" \
                -e "/DB_PASSWORD/{s#password_here#${propList[PASSWORD]}#g}" \
                -e "/DB_HOST/{s#localhost#${propList[HOSTNAME]}#g}" \
                $WP_CONFIG_FILE || \
                exit_error "Error: Update of file $WP_CONFIG_FILE failed"
          console_msg "Info: Updated $WP_CONFIG_FILE file"
    fi
}

###############################################################################
# Main Declaration
###############################################################################

get_wordpress_conf_properties
update_wordpress_database_details