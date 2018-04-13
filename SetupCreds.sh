function password() {
  local need_password=1
  local bad_attempt=0
  local confirm=""

  while [[ $need_password -eq 1 ]]
  do
    if [[ $bad_attempt -eq 1 ]]; then
      echo "Passwords Must Match"
    fi
    echo "Please Enter Password For $1"
    echo -n "Password: "
    read -s password
    echo

    echo -n "Confirm: "
    read -s confirm
    echo

    if [[ $password = $confirm ]]; then
      need_password=0
    else
      bad_attempt=1
    fi
    eval "${2}=$password"
  done
}

function json_object() {
  local str=""
  local i=0

  for j in "$@"
  do
    if [[ $i -gt 0 ]]; then
      str="${str},"
    fi

    str="$str$j"
    i=$i+1
  done

  echo "{ $str }"
}

function json_pair() {
  echo "\"$1\": \"$2\""
}

function json_secret() {
  local key=$(printf '%q' $1)
  local value=$(printf '%q' $2)
  local pass=$(printf '%q' $3)
  local file=$(printf '%q' $4)

  key=$(json_pair key $key)
  value=$(json_pair value $value)
  pass=$(json_pair pass $pass)
  file=$(json_pair store $file)

  local result=$(json_object "$key" "$value" "$pass" "$file")

  echo "$result"
}

echo "First we need to configure your Keyring"
password Keyring keyring_pass

echo "Next we need a password for the Credentials Store"
password credentials credentials_pass

echo "Next we need a MySql root Password"
password Mysql mysql_pass

credentials_secret=$(json_secret credentials "${credentials_pass}" "${keyring_pass}" node_app_keyring)
mysql_user_secret=$(json_secret db_user root "${credentials_pass}" "credentials")
mysql_pass_secret=$(json_secret db_pass "${mysql_pass}" "${credentials_pass}" "credentials")

echo $credentials_secret | secrets
echo $mysql_user_secret | secrets
echo $mysql_pass_secret | secrets
