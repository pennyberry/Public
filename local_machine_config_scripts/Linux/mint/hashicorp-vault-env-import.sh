#import vault command
if ! command -v vault &> /dev/null; then
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install vault
else
  echo "vault command already exists"
fi
#import jq command
if ! command -v jq &> /dev/null; then
  sudo apt update && sudo apt install jq
else
  echo "jq command already exists"
fi

#login to vault
read -rsp $'Enter your vault address - https://your-vault-address.domain.tld \n' vault_address
export VAULT_ADDR=$vault_address
export VAULT_FORMAT=json
echo "VAULT_ADDR set to $VAULT_ADDR"
read -rsp $'Enter your vault token - login to vault - top right - copy token \n' vault_token
vault login $vault_token

#get the repo name and path
read -rsp $'Enter the name of your repo \n' repo_name
read -rsp $'Enter the path to your local repo \n' repo_path
read -rsp $'Enter the vault engine name - e.g. kv/ \n' vault_path

function traverse {
    local -r path="$1"

    result=$(vault kv list -format=json $path 2>&1)

    status=$?
    if [ ! $status -eq 0 ];
    then
        if [[ $result =~ "permission denied" ]]; then
            return
        fi
        >&2 echo "$result"
    fi

    for secret in $(echo "$result" | jq -r '.[]'); do
        if [[ "$secret" == */ ]]; then
            traverse "$path$secret"
        else
            echo "$path$secret"
        fi
    done
}

#get the secret data from each path and write it to the local repo
for path in $(traverse $vault_path); do
    secret=$(vault kv get -format=json $path | jq -r '.data.data.content')
    relative_path=${path#$vault_path}
    relative_path=${relative_path#$repo_name/}
    corrected_path=$repo_path/$relative_path
    echo "writing file to path $corrected_path"
    echo "$secret" > "$corrected_path"
done
