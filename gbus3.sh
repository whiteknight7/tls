#!/bin/bash

read -p 'URL: ' url

gobuster dir -u $url -w /opt/SecLists/Discovery/Web-Content/common.txt -x .php,.txt,.php.bak,.docx -b 403,404
gobuster dir -u $url -w /opt/SecLists/Discovery/Web-Content/big.txt -x .php,.txt,.php.bak,.docx -b 403,404
gobuster vhost -u $url -w /opt/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt | grep "Status: 200"
gobuster vhost -u $url -w /opt/SecLists/Discovery/Web-Content/big.txt | grep "Status: 200"
gobuster dir -u $url -w /opt/SecLists/Discovery/Web-Content/directory-list-2.3-big.txt -t 100 -e -b 403,404
gobuster vhost -u $url -w /opt/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
