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

  # eval '${5}="cat $(echo \"$result\")"'

  echo "$result"
}

hello=$(json_secret key "hell \" \" lo ad££" "password" "file" testing)
echo $hello | secrets


    #
    #   \"key\": \"${sanitized_key}\",
    #   \"value\": \"${sanitized_value}\",
    #   \"password\": \"${sanitized_password}\",
    #   \"store\": \"${sanitized_file}\"
    # }


