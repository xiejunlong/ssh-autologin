#!/usr/bin/expect

set SERVER_NAME [lindex $argv 0]
set IP [lindex $argv 1]
set PORT [lindex $argv 2]
set USER_NAME [lindex $argv 3]
set PASSWORD [lindex $argv 4]
set SUDO_ROOT [lindex $argv 5]
set COMMAND [lindex $argv 6]

spawn ssh -p $PORT $USER_NAME@$IP

expect {
    -timeout 300
    "*assword" { send "$PASSWORD\r\n"; exp_continue ; sleep 3; }
    "yes/no" { send \"yes\n\"; exp_continue; }
    "Last*" {
        puts "\n\[$USER_NAME\]登录\[$SERVER_NAME\]成功\n";
#        send "PROMPT_COMMAND='echo -ne \"\\033]0;$SERVER_NAME \\007\"' \r";
        send -- "clear\r";
    }
    timeout { puts "Expect was timeout."; return }
}

if { "$SUDO_ROOT" == 1 } {
    puts "\[$USER_NAME\] 正在 sudo -i\n"
    expect "${USER_NAME}@"
    send "sudo -i\n"
    expect "${USER_NAME}:"
    send "$PASSWORD\r\n"
    expect "~]#"
    send -- "clear\r";
}

if { "$COMMAND" != "" } {
    send -- "$COMMAND\r"
}

# 登录后要运行的其他命令
#send -- "alias ls='ls -F --color'\n"
#send -- "alias ll='ls -l'\n"
#send -- "alias grep='grep --color'\n"
#send -- "alias egrep='egrep --color'\n"

interact
