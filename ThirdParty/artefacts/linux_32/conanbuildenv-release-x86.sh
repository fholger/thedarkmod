script_folder="/mnt/hgfs/thedarkmod/darkmod_src/ThirdParty/artefacts/linux_32"
echo "echo Restoring environment" > "$script_folder/deactivate_conanbuildenv-release-x86.sh"
for v in 
do
    is_defined="true"
    value=$(printenv $v) || is_defined="" || true
    if [ -n "$value" ] || [ -n "$is_defined" ]
    then
        echo export "$v='$value'" >> "$script_folder/deactivate_conanbuildenv-release-x86.sh"
    else
        echo unset $v >> "$script_folder/deactivate_conanbuildenv-release-x86.sh"
    fi
done

