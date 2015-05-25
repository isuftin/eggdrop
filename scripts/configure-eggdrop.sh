#!/bin/bash

# Reference: http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?revision=1.69

eggdrop_home="/home/${eggdrop_user}"
backup_suffix=".bak"
scripts_directory=${scripts_directory:-"scripts/"}
config_directory=${config_directory:-"/configs/"}
logs_dir=${logs_directory:-"/logs/"}

# First make sure all mandatory variables exist
# Ex: listen_ports="64738|bots;64738|users;64738|all"
if [ ! -n "$listen_ports" ]; then echo "Variable \"listen_ports\" is mandatory";exit 1;fi
# Ex: owner="myself"
if [ ! -n "$owner" ]; then echo "Variable \"owner\" is mandatory";exit 1;fi
# Ex: eggdrop_nickname="lamestbot"
if [ ! -n "$eggdrop_nickname" ]; then echo "Variable \"eggdrop_nickname\" is mandatory";exit 1;fi

##### BASIC SETTINGS #####

# Set eggdrop executable
eggdrop_exec=$eggdrop_home"/eggdrop"
echo "#! $eggdrop_exec"

# Set username
username=${username:-lamest}
echo "set username \"${username}\"" 

# Set admin
admin=${admin:-Lamer <email\: lamer\@lamest.lame.org>}
echo "set admin \"${admin}\"" 

# Set network
network=${network:-"I.didnt.properly.set.my.variables.net"}
echo "set network \"${network}\"" 

# Set timezone
timezone=${timezone:-EST}
echo "set timezone \"${timezone}\"" 

# Set offset
offset=${offset:-\-5}
echo "set offset \"${offset}\"" 

# Uncomment TZ env
if [ -n "$tz_env" ]; then
    echo "set env(TZ) \"\$timezone\$offset\"" 
fi

# Set hostnme, ip or none
if [ ! -n $my_hostname ]; then
    echo "set my-hostname \"${my_hostname}\"" 
elif [ ! -n $my_ip ]; then
    echo "set my-ip \"${my_ip}\"" 
fi

# Set language (Danish, English, French, Finnish, German)
if [ -n "${lang}" ]; then
    echo "addlang \"${lang}\"" 
fi

##### LOG FILES #####

# Set max logs (suggested not to touch this)
max_logs=${max_logs:-5}
echo "set max-logs ${max_logs}" 

# Set max log size in kilobytes
max_logsize=${max_logsize:-0}
echo "set max-logsize ${max_logsize}" 

# Set quicklogs
quicklogs=${quicklogs:-0}
echo "set quick-logs ${quicklogs}" 

# Set rawlogs
rawlog=${rawlog:-0}
echo "set raw-log ${rawlog}" 

# Set logfiles
# This variable is 1..n. When setting more than a single log file,
# split each log file line with ';' and each log file is delimited by '|'
 
# Multiple logfiles examples: 
# logfiles="mco|*|logs/eggdrop.log;jpk|#lamest|logs/lamest.log;"
logfiles=${logfiles:-"mco|*|${logs_dir}/eggdrop.log;"}
IFS=';' read -a logfiles_arr <<< "$logfiles"
for logline in "${logfiles_arr[@]}"; do
    IFS='|' read -a logfile <<< "$logline"
    echo "logfile ${logfile[0]} ${logfile[1]} \"${logfile[2]}\"" 
done

# Set log time
logtime=${logtime:-1}
echo "set log-time ${logtime}" 

# Set timestamp format
ts_format=${ts_format:-\{[%H:%M:%S]\}}
echo "set timestamp-format ${ts_format}" 

# Set keep-all-logs
keep_all_logs=${keep_all_logs:-0}
echo "set keep-all-logs ${keep_all_logs}" 

# Set logfile suffix
logfile_suffix=${logfile_suffix:-".%d%b%Y"}
echo "set logfile-suffix \"${logfile_suffix}\"" 

# Set switch logfiles at
switch_logfiles_at=${switch_logfiles_at:-300}
echo "set switch-logfiles-at ${switch_logfiles_at}" 

# Set quiet save
quiet_save=${quiet_save:-0}
echo "set quiet-save ${quiet_save}" 

##### CONSOLE #####

# Set console
console=${console:-mkcobxs}
echo "set console \"${console}\"" 

##### FILES AND DIRECTORIES #####

# Set userfile
userfile=${userfile:-${eggdrop_nickname}.user}
echo "set userfile \"${config_directory}${userfile}\"" 

# Set pidfile
pidfile=${pidfile:-"pid.${eggdrop_nickname}"}
echo "set pidfile \"${pidfile}\""

# Set sort users
sort_users=${sort_users:-0}
echo "set sort-users ${sort_users}" 

# Set help path
help_path=${help_path:-help/}
echo "set help-path \"${help_path}\"" 

# Set text path
text_path=${text_path:-text/}
echo "set text-path \"${text_path}\"" 

# Set temp path
temp_path=${temp_path:-/tmp}
echo "set temp-path \"${temp_path}\"" 

# Set motd
motd=${motd:-text/motd}
echo "set motd \"${motd}\"" 

# Set Telnet banner
telnet_banner=${telnet_banner:-text/banner}
echo "set telnet-banner \"${telnet_banner}\"" 

# Set userfile permissions
userfile_perm=${userfile_perm:-0600}
echo "set userfile-perm ${userfile_perm}" 

##### BOTNET/DCC/TELNET #####

# Set botnet nickname
botnet_nick=${botnet_nick:-${eggdrop_nickname}}
echo "set botnet-nick \"${botnet_nick}\"" 

# Set listen
# This variable is 1..n. When setting more than a single port,
# split each port line with ';' and each port line is delimited by '|'
 
# Multiple port sexamples: 
# listen_ports="64738|bots;64738|users;64738|all"
IFS=';' read -a ports_arr <<< "$listen_ports"
for port_line in "${ports_arr[@]}"; do
    IFS='|' read -a port <<< "$port_line"
    echo "listen ${port[0]} ${port[1]}" 
done

# Set remote boots
remote_boots=${remote_boots:-2}
echo "set remote-boots ${remote_boots}"  

# Set share-unlinks
share_unlinks=${share_unlinks:-1}
echo "set share-unlinks ${share_unlinks}"  

# Set protect telnet
protect_telnet=${protect_telnet:-0}
echo "set protect-telnet ${protect_telnet}"  

# Set DCC Sanitycheck
dcc_sanitycheck=${dcc_sanitycheck:-0}
echo "set dcc-sanitycheck ${dcc_sanitycheck}"  

# Set ident timeout
ident_timeout=${ident_timeout:-5}
echo "set ident-timeout ${ident_timeout}"  

# Set require p
require_p=${require_p:-1}
echo "set require-p ${require_p}"  

# Set open telnets
open_telnets=${open_telnets:-0}
echo "set open-telnets ${open_telnets}"  

# Set stealth telnets
stealth_telnets=${stealth_telnets:-0}
echo "set stealth-telnets ${stealth_telnets}"  

# Set use telnet banner
use_telnet_banner=${use_telnet_banner:-0}
echo "set use-telnet-banner ${use_telnet_banner}"  

# Set connect timeout
connect_timeout=${connect_timeout:-15}
echo "set connect-timeout ${connect_timeout}"  

# Set DCC flood thr
dcc_flood_thr=${dcc_flood_thr:-3}
echo "set dcc-flood-thr ${dcc_flood_thr}"  

# Set telnet flood
telnet_flood=${telnet_flood:-5\:60}
echo "set telnet-flood ${telnet_flood}"  

# Set Paranoid Telnet Flood
paranoid_telnet_flood=${paranoid_telnet_flood:-1}
echo "set paranoid-telnet-flood ${paranoid_telnet_flood}"  

# Set Resolve Timeout
resolve_timeout=${resolve_timeout:-7}
echo "set resolve-timeout ${resolve_timeout}"  

##### MORE ADVANCED SETTINGS #####

# Set firewall (if avail)
if [ ! -n $firewall ]; then
    sed -i "329s/.*/set firewall \"${firewall}\"/" $conf_file 
fi

# Set nat ip
if [ ! -n $nat_ip ]; then
    echo "set nat-ip \"${nat_ip}\""  
fi

# Set reserved port range
if [ ! -n $reserved_portrange ]; then
    echo "set reserved-portrange ${reserved_portrange}"  
fi

# Set Ignore TIme
ignore_time=${ignore_time:-15}
    echo "set ignore-time ${ignore_time}"  

# Set hourly updates
hourly_updates=${hourly_updates:-00}
echo "set hourly-updates ${hourly_updates}"  

# Set Owner (Mandatory)
echo "set owner \"${owner}\""  

# Set notify newusers (who should get this?)
if [ ! -n "$notify_newusers" ]; then
    echo "set notify-newusers \"${notify_newusers}\""  
else
    echo "set notify-newusers \$owner"  
fi

# Set default flags
default_flags=${default_flags:-hp}
echo "set default-flags \"${default_flags}\"" 

# Set whois fields
whois_fields=${whois_fields:-url birthday}
echo "set whois-fields \"${whois_fields}\"" 

# Set die on sighup
die_on_sighup=${die_on_sighup:-0}
echo "set die-on-sighup ${die_on_sighup}" 

# Set die on sigterm
die_on_sigterm=${die_on_sigterm:-1}
echo "set die-on-sigterm ${die_on_sigterm}" 

# Set unbind TCL
if [ ! -n $unbind_tcl]; then
    echo "unbind dcc n tcl *dcc:tcl" 
fi

# Set unbind TCL
if [ ! -n $unbind_set]; then
    echo "unbind dcc n set *dcc:set" 
fi

# Set Must Be Owner
must_be_owner=${must_be_owner:-1}
echo "set must-be-owner ${must_be_owner}" 

# Set Set simul for partyline 
if [ -n $bind_simul ]; then
    echo "unbind dcc n tcl *dcc:tcl" 
fi

# Set Max Socks
max_socks=${max_socks:-100}
echo "set max-socks ${max_socks}" 

# Set Allow DK Commands
allow_dk_commands=${allow_dk_commands:-1}
echo "set allow-dk-cmds ${allow_dk_commands}" 

# Set dupwait timeout
dupwait_timeout=${dupwait_timeout:-5}
echo "set dupwait-timeout ${dupwait_timeout}" 

# Set strict host
strict_host=${strict_host:-1}
echo "set strict-host ${strict_host}" 

# Set CIDR host
cidr_support=${cidr_support:-0}
echo "set cidr-support ${cidr_support}" 

##### MODULES #####

# Set modules path
mod_path=${mod_path:-modules/}
echo "set mod-path \"${mod_path}\"" 

#### BLOWFISH MODULE ####

# Set encryption module
encryption_module=${encryption_module:-blowfish}
echo "loadmodule ${encryption_module}" 

#### DNS MODULE ####
echo "loadmodule dns" 

# Set DNS servers
if [ -n "$dns_servers" ]; then
    echo "set dns-servers \"${dns_servers}\"" 
fi

# Set DNS Cache
dns_cache=${dns_cache:-86400}
echo "set dns-cache ${dns_cache}" 

# Set DNS Neg Cache
dns_neg_cache=${dns_neg_cache:-600}
echo "set dns-negcache ${dns_neg_cache}" 

# Set DNS Max Sends
dns_max_sends=${dns_max_sends:-4}
echo "set dns-maxsends ${dns_max_sends}" 

# Set DNS retry delay
dns_retry_delay=${dns_retry_delay:-3}
echo "set dns-retrydelay ${dns_retry_delay}" 

#### CHANNELS MODULE ####

echo "loadmodule channels" 

# Set chanfile
chanfile=${chanfile:-${eggdrop_nickname}".chan"}
echo "set chanfile \"${chanfile}\"" 

# Set force expire
force_expire=${force_expire:-0}
echo "set force-expire ${force_expire}" 

# Set share greet
share_greet=${share_greet:-0}
echo "set share-greet ${share_greet}" 

# Set use info
use_info=${use_info:-1}
echo "set use-info ${use_info}" 

# Set Allow PS
allow_ps=${allow_ps:-0}
echo "set allow-ps ${allow_ps}" 

# Set global flood chan
global_flood_chan=${global_flood_chan:-15\:60}
echo "set global-flood-chan ${global_flood_chan}" 

# Set global flood deop
global_flood_deop=${global_flood_deop:-3\:10}
echo "set global-flood-deop ${global_flood_deop}" 

# Set global flood kick
global_flood_kick=${global_flood_kick:-3\:10}
echo "set global-flood-kick ${global_flood_kick}" 

# Set global flood join
global_flood_join=${global_flood_join:-5\:60}
echo "set global-flood-join ${global_flood_join}" 

# Set global flood ctcp
global_flood_ctcp=${global_flood_ctcp:-5\:60}
echo "set global-flood-ctcp ${global_flood_ctcp}" 

# Set global flood nick
global_flood_nick=${global_flood_nick:-5\:60}
echo "set global-flood-nick ${global_flood_nick}" 

# Set global aop delay
global_aop_delay=${global_aop_delay:-5\:30}
echo "set global-aop-delay ${global_aop_delay}" 

# Set global idle kick
global_idle_kick=${global_idle_kick:-0}
echo "set global-idle-kick ${global_idle_kick}" 

# Set Global chanmode
global_chanmode=${global_chanmode:-nt}
echo "set global-chanmode \"${global_chanmode}\"" 

# Set global stop nethack mode
global_stopnethack=${global_stopnethack:-0}
echo "set global-stopnethack-mode ${global_stopnethack}" 

# Set global revenge mode
global_revenge_mode=${global_revenge_mode:-0}
echo "set global-revenge-mode ${global_revenge_mode}" 

# Set global ban type
global_ban_type=${global_ban_type:-3}
echo "set global-ban-type ${global_ban_type}" 

# Set global ban time
global_ban_time=${global_ban_time:-120}
echo "set global-ban-time ${global_ban_time}" 

# Set global exempt time
global_exempt_time=${global_exempt_time:-60}
echo "set global-exempt-time ${global_exempt_time}" 

# Set global invite time
global_invite_time=${global_invite_time:-60}
echo "set global-invite-time ${global_invite_time}" 

global_chanset=${global_chanset:-"-autoop,-autovoice,-bitch,+cycle,+dontkickops,\
+dynamicbans,+dynamicexempts,+dynamicinvites,-enforcebans,+greet,-inactive,\
-nodesynch,-protectfriends,+protectops,-revenge,-revengebot,-secret,-seen,\
+shared,-statuslog,+userbans,+userexempts,+userinvites,-protecthalfops,\
-autohalfop,-static"}
echo "set global-chanset {" 
IFS=',' read -a chanset_arr <<< "$global_chanset"
for chanset in "${chanset_arr[@]}"; do
    echo -e "\t${chanset}" 
done
echo "}" 

if [ -n "$chan" ]; then 
    IFS=';' read -a chan_arr <<< "$chan"
    for channel in "${chan_arr[@]}"; do
        echo "channel add #${channel}" 
    done 
fi

#### SERVER MODULE ####

echo "loadmodule server"

# Set subnet type
net_type=${net_type:-0}
echo "set net-type ${net_type}"

echo "set nick \"${eggdrop_nickname}\""

# Set alternate nickname
alt_nick=${altnick:-$(echo $eggdrop_nickname | sed 's/.\{3\}/&?/g')}
echo "set altnick \"${alt_nick}\""

# Set realname
realname=${realname:-"/msg ${eggdrop_nickname} hello"}
echo "set realname \"${realname}\""

# Set init server event
init_svr_evt=${init_svr_evt:-evnt\:init_server}
echo "bind evnt - init-server ${init_svr_evt}"

# Define init_server
init_server_proc=${init_server_proc:-"global botnick;putquick \"MODE \$botnick +i-ws\""}
echo "proc $init_svr_evt {type} {" 
IFS=';' read -a srv_evt_arr <<< "$init_server_proc"
for evt in "${srv_evt_arr[@]}"; do
    echo -e "\t${evt}" 
done
echo "}" 

# Set default port
default_port=${default_port:-6667}
echo "set default-port ${default_port}"

# Define server list
# Pipe delimited, server[:port[:password]]
server_list=${server_list:-"irc.efnet.org:6667|irc.efnet.info"}
echo "set servers {" 
IFS='|' read -a srv_arr <<< "$server_list"
for srv in "${srv_arr[@]}"; do
    echo -e "\t${srv}" 
done
echo "}" 

# Set msg rate
msg_rate=${msg_rate:-2}
echo "set msg-rate ${msg_rate}"

# Set keep nick
keep_nick=${keep_nick:-1}
echo "set keep-nick ${keep_nick}"

# Set quiet reject
quiet_reject=${quiet_reject:-1}
echo "set quiet-reject ${quiet_reject}"

# Set lowercase ctcp
lowercase_ctcp=${lowercase_ctcp:-0}
echo "set lowercase-ctcp ${lowercase_ctcp}"

# Set answer ctcp
answer_ctcp=${answer_ctcp:-3}
echo "set answer-ctcp ${answer_ctcp}"

# Set flood msg
flood_msg=${flood_msg:-5\:60}
echo "set flood-msg ${flood_msg}"

# set flood ctcp
flood_ctcp=${flood_ctcp:-3\:60}
echo "set flood-ctcp ${flood_ctcp}"

# Set never give up
never_give_up=${never_give_up:-1}
echo "set never-give-up ${never_give_up}"

# Set server cycle wait
server_cycle_wait=${server_cycle_wait:-60}
echo "set server-cycle-wait ${server_cycle_wait}"

# Set server timeout
server_timeout=${server_timeout:-60}
echo "set server-timeout ${server_timeout}"

# Set servlimit
servlimit=${servlimit:-0}
echo "set servlimit ${servlimit}"

# Set checkstoned
check_stoned=${check_stoned:-1}
echo "set check-stoned ${check_stoned}"

# Set server error quit
serverror_quit=${serverror_quit:-1}
echo "set serverror-quit ${serverror_quit}"

# Set max queue message
max_queue_msg=${max_queue_msg:-300}
echo "set max-queue-msg ${max_queue_msg}"

# Set trigger on ignore
trigger_on_ignore=${trigger_on_ignore:-0}
echo "set trigger-on-ignore ${trigger_on_ignore}"

# set exclusive binds
exclusive_binds=${exclusive_binds:-0}
echo "set exclusive-binds ${exclusive_binds}"

# set double mode
double_mode=${double_mode:-1}
echo "set double-mode ${double_mode}"

# set double server
double_server=${double_server:-1}
echo "set double-server ${double_server}"

# set double help
double_help=${double_help:-1}
echo "set double-help ${double_help}"

# Set optimize kicks
optimize_kicks=${optimize_kicks:-1}
echo "set optimize-kicks ${optimize_kicks}"

# Set stack limit
stack_limit=${stack_limit:-1}
echo "set stack-limit ${stack_limit}"

### SERVER MODULE - OTHER NETWORKS (net-type 5) ###
# Set check mode r
if [ ! -n $check_mode_r ]; then
    echo "set check-mode-r 1"
fi

# Set nickname length
nick_len=${nick_len:-9}
echo "set nick-len ${nick_len}"

echo "loadmodule ctcp"

# Set CTCP mode
ctcp_mode=${ctcp_mode:-0}
echo "set ctcp-mode ${ctcp_mode}"

# Set CTCP version
ctcp_version=${ctcp_version:-0}
echo "set ctcp-version ${ctcp_version}"

# Set CTCP userinfo
ctcp_userinfo=${ctcp_userinfo:-0}
echo "set ctcp-userinfo ${ctcp_userinfo}"

#### IRC MODULE ####
echo "loadmodule irc"

# Set bounce bans
bounce_bans=${bounce_bans:-0}
echo "set bounce-bans ${bounce_bans}"

# Set bounce exempts
bounce_exempts=${bounce_exempts:-0}
echo "set bounce-exempts ${bounce_exempts}"

# Set bounce invites
bounce_invites=${bounce_invites:-0}
echo "set bounce-invites ${bounce_invites}"

# Set bounce modes
bounce_modes=${bounce_modes:-0}
echo "set bounce-modes ${bounce_modes}"

# Set max bans
max_bans=${max_bans:-30}
echo "set max-bans ${max_bans}"

# Set max exempts
max_exempts=${max_exempts:-20}
echo "set max-exempts ${max_exempts}"

# Set max invites
max_invites=${max_invites:-20}
echo "set max-invites ${max_invites}"

# Set max modes
max_modes=${max_modes:-30}
echo "set max-modes ${max_modes}"

# Set use-exempts
if [ -n "${use_exempts}" ]; then 
    echo "set use-exempts ${use_exempts}"
fi

# Set use-invites
if [ -n "${use_invites}" ]; then 
    echo "set use-invites ${use_invites}"
fi

# Set kick fun
kick_fun=${kick_fun:-0}
echo "set kick-fun ${kick_fun}"

# Set ban fun
ban_fun=${ban_fun:-0}
echo "set ban-fun ${ban_fun}"

# Set learn users
learn_users=${learn_users:-0}
echo "set learn-users ${learn_users}"

# Set wait split
wait_split=${wait_split:-600}
echo "set wait-split ${wait_split}"

# Set wait info
wait_info=${wait_info:-180}
echo "set wait-info ${wait_info}"

# Set mode buffer length
mode_buf_length=${mode_buf_length:-200}
echo "set mode-buf-length ${mode_buf_length}"

# Rebind hello to
rebind_hello=${rebind_hello:-hellohello}
echo "unbind msg - hello *msg:hello"
echo "bind msg - ${rebind_hello} *msg:hello"

# Rebind ident and adhost to
rebind_ident=${rebind_ident:-identident}
rebind_addhost=${rebind_addhost:-addhostaddhost}
echo "unbind msg - ident *msg:ident"
echo "bind msg - ${rebind_ident} *msg:ident"
echo "unbind msg - addhost *msg:addhost"
echo "bind msg - ${rebind_addhost} *msg:addhost"

# Set opchars, comma delim
opchars=${opchars:-"@;"}
IFS=';' read -a opchars_arr <<< "$opchars"
for opchar in "${opchars_arr[@]}"; do
    echo -e "set opchars \"${opchar}\"" 
done

# Set no chanrec info
no_chanrec_info=${no_chanrec_info:-0}
echo "set no-chanrec-info ${no_chanrec_info}"

# Set prevent mixing
prevent_mixing=${prevent_mixing:-1}
echo "set prevent-mixing ${prevent_mixing}"

# Set kick method
if [ -n "${kick_method}" ]; then
    echo "set kick-method ${kick_method}"
fi

if [ ${net_type} -eq 5 ]; then
    # Set modes per line
    if [ -n "${modes_per_line}" ]; then
        echo "set modes-per-line ${modes_per_line}"
    fi

    # Set include lk
    if [ -n "${include_lk}" ]; then
        echo "set include-lk ${include_lk}"
    fi

    # Set use 354
    if [ -n "${use_354}" ]; then
        echo "set use-354 ${use_354}"
    fi

    # Set rfc compliant
    if [ -n "${rfc_compliant}" ]; then
        echo "set rfc-compliant ${rfc_compliant}"
    fi
fi

#### TRANSFER MODULE ####
# Load module transfer
if [ -n "${loadmodule_transfer}" ]; then
    echo "loadmodule transfer"
    
    # Set max downloads
    max_dloads=${max_dloads:-3}
    echo "set max-dloads ${max_dloads}"

    # Set DCC block
    dcc_block=${dcc_block:-0}
    echo "set dcc-block ${dcc_block}"

    # Set copy to temp
    copy_to_tmp=${copy_to_tmp:-1}
    echo "set copy-to-tmp ${copy_to_tmp}"

    # Set xfer timeout
    xfer_timeout=${xfer_timeout:-30}
    echo "set xfer-timeout ${xfer_timeout}"
fi

#### SHARE MODULE ####
# Load module share
if [ -n "${loadmodule_share}" ]; then
    echo "loadmodule share"
    
    # Set allow resync
    allow_resync=${allow_resync:-0}
    echo "set allow-resync ${allow_resync}"
    
    # Set resync time
    resync_time=${resync_time:-900}
    echo "set resync-time ${resync_time}"
    
    # Set private global
    private_global=${private_global:-0}
    echo "set private-global ${private_global}"

    # Set private globals
    private_globals=${private_globals:-mnot}
    echo "set private-globals \"${private_globals}\""
    
    # Set private user
    private_user=${private_user:-0}
    echo "set private-user ${private_user}"
    
    # Set override bots
    override_bots=${override_bots:-0}
    echo "set override-bots ${override_bots}"
fi

#### COMPRESS MODULE ####
if [ -n "${loadmodule_compress}" ]; then
    echo "loadmodule compress"
    
    # Set share compress
    share_compressed=${share_compressed:-1}
    echo "set share-compressed ${share_compressed}"
    
    # Set compress level
    compress_level=${compress_level:-9}
    echo "set compress-level ${compress_level}"
fi

#### FILESYSTEM MODULE ####
if [ -n "${loadmodule_filesys}" ]; then
    echo "loadmodule filesys"
    
    # Set files path
    files_path=${files_path:-"/tmp"}
    echo "set files-path \"${files_path}\""
    
    # Set incoming path
    incoming_path=${incoming_path:-"/tmp"}
    echo "set incoming-path \"${incoming_path}\""
    
    # Set upload to pwd
    upload_to_pwd=${upload_to_pwd:-0}
    echo "set upload-to-pwd ${upload_to_pwd}"
    
    # Set filedb path
    filedb_path=${filedb_path:-""}
    echo "set filedb-path \"${filedb_path}\""
    
    # Set max file users
    max_file_users=${max_file_users:-20}
    echo "set max-file-users ${max_file_users}"
    
    # Set max filesize
    max_filesize=${max_filesize:-1024}
    echo "set max-filesize ${max_filesize}"
fi

#### NOTES MODULE ####
echo "loadmodule notes"

# Set notefile
notefile=${notefile:-${eggdrop_nickname}.notes}
echo "set notefile \"${notefile}\""

# Set max notes
max_notes=${max_notes:-50}
echo "set max-notes ${max_notes}"

# Set note life
note_life=${note_life:-60}
echo "set note-life ${note_life}"

# Set allow fwd
allow_fwd=${allow_fwd:-0}
echo "set allow-fwd ${allow_fwd}"

# Set Notify users
notify_users=${notify_users:-0}
echo "set notify-users ${notify_users}"

# Set notify onjoin
notify_onjoin=${notify_onjoin:-1}
echo "set notify-onjoin ${notify_onjoin}"

#### CONSOLE MODULE ####
echo "loadmodule console"

# Set console autosave
console_autosave=${console_autosave:-1}
echo "set console-autosave ${console_autosave}"

# Set force channel
force_channel=${force_channel:-0}
echo "set force-channel ${force_channel}"

# Set info party
info_party=${info_party:-0}
echo "set info-party ${info_party}"

#### SEEN MODULE ####
if [ -n ${loadmodule_seen} ]; then
    echo "loadmodule seen"
fi

#### ASSOC MODULE ####
if [ -n ${loadmodule_assoc} ]; then
    echo "loadmodule assoc"
fi

#### WIRE MODULE ####
if [ -n ${loadmodule_wire} ]; then
    echo "loadmodule wire"
fi

#### UPTIME MODULE ####
if [ -n ${loadmodule_uptime} ]; then
    echo "loadmodule uptime"
fi

##### SCRIPTS #####
scripts=${scripts:-"alltools.tcl,action.fix.tcl,dccwhois.tcl,userinfo.tcl,quotepong.tcl,quotepass.tcl"}
IFS=',' read -a scripts_arr <<< "$scripts"
for script in "${scripts_arr[@]}"; do
    echo "source $scripts_directory$script" 
done

loadhelp=${loadhelp:-"userinfo.help"}
IFS=',' read -a loadhelp_arr <<< "$loadhelp"
for lh in "${loadhelp_arr[@]}"; do
    echo "loadhelp $lh" 
done
