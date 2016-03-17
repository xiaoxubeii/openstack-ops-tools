#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --disable
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone  Asia/Shanghai
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
part /boot --fstype="xfs" --size=200 --asprimary
part / --fstype="xfs" --size=1024 --grow
part swap --fstype="swap" --size=1024

%pre
$SNIPPET('pre_install_network_config')
$SNIPPET('pre_anamon')
%end

%packages
@Base
%end

%post
$yum_config_stanza
$SNIPPET('post_install_network_config')
$SNIPPET('post_sshkeys')
$SNIPPET('post_anamon')

mkdir depoenstack && curl $op_dep_pkg| tar xzC depopenstack && cd *

cat <<EOF > local.conf
[[local|localrc]]
STACK_USER=$stack_user
HOST_IP=$host_ip
SERVICE_HOST=$service_host
SERVICE_PASSWORD=$service_password
MYSQL_PASSWORD=$mysql_password
RABBIT_HOSTS=$rabbit_hosts
SERVICE_TOKEN=$service_token
DEST=$dest
NEUTRON_ML2_TENANT_NETWORK_TYPE=$neutron_ml2_tenant_network_type
OVS_ENABLE_TUNNELING=$ovs_enable_tunneling
TUNNEL_ENDPOINT_IP=$tunnel_endpoint_ip
OP_PKG_URL=$op_pkg_url
EOF

./tools/create-stack-user.sh
chown -R $stack_user:$stack_user \${PWD}
mv \${PWD} $dest
opdir=\${PWD\#\#*/}
su - $stack_user
cd \$opdir
./stack.sh

%end
