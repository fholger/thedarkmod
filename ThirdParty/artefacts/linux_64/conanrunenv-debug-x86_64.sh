script_folder="/mnt/hgfs/thedarkmod/darkmod_src/ThirdParty/artefacts/linux_64"
echo "echo Restoring environment" > "$script_folder/deactivate_conanrunenv-debug-x86_64.sh"
for v in ALSA_CONFIG_DIR
do
    is_defined="true"
    value=$(printenv $v) || is_defined="" || true
    if [ -n "$value" ] || [ -n "$is_defined" ]
    then
        echo export "$v='$value'" >> "$script_folder/deactivate_conanrunenv-debug-x86_64.sh"
    else
        echo unset $v >> "$script_folder/deactivate_conanrunenv-debug-x86_64.sh"
    fi
done


export ALSA_CONFIG_DIR="$script_folder/../tdm_deploy/libalsa/res/alsa"