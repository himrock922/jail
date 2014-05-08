#!/usr/local/bin/bash
mkdir -p /jail
mount -t tmpfs tmpfs /jail
sysctl security.jail.mount_devfs_allowed=1
sysctl security.jail.mount_procfs_allowed=1
for i in 1 2 3 4 5 6 7 8 9 
do
	mkdir -p /jail/jail${i}
	mkdir -p /jail/jail${i}/dev
	mount -t devfs devfs /jail/jail${i}/dev
	mkdir -p /jail/jail${i}/proc
	mount -t procfs proc /jail/jail${i}/proc
	for d in lib libexec etc bin sbin usr var
	do
		mkdir -p /jail/jail${i}/${d}
		mount -t nullfs /${d} /jail/jail${i}/${d}
	done
	jail -c persist vnet jid=${i} path=/jail/jail${i} host.hostname=jail-${i}
done

for i in 1 2 3 4 
do
		ifconfig epair${i} create
		ifconfig epair${i}b vnet ${i}
		jexec ${i} sysctl net.inet.ip.forwarding=1
		jexec ${i} /etc/rc.d/sshd onestart
		jexec ${i} ifconfig epair${i}b name lan0
		jexec ${i} ifconfig lan0 inet6 -ifdisabled accept_rtadv up

		jexec ${i} routed -s -m
		jexec ${i} route add default 192.168.${i}.1
done

		ifconfig epair1a inet 192.168.1.1/24
		ifconfig epair2a inet 192.168.2.1/24
		ifconfig epair3a inet 192.168.3.1/24
		ifconfig epair4a inet 192.168.4.1/24

		jexec 1 ifconfig lan0 inet 192.168.1.2/24
		jexec 2 ifconfig lan0 inet 192.168.2.2/24
		jexec 3 ifconfig lan0 inet 192.168.3.2/24
		jexec 4 ifconfig lan0 inet 192.168.4.2/24


for i in 5 6 7 8 9
do
		ifconfig epair${i} create
		jexec ${i} sysctl net.inet.ip.forwarding=1
		jexec ${i} /etc/rc.d/sshd onestart
		jexec ${i} routed -s -m
done
		ifconfig epair5a vnet 1
		ifconfig epair6a vnet 1
		jexec 1 ifconfig epair5a name lan1
		jexec 1 ifconfig epair6a name lan2
		jexec 1 ifconfig lan1 inet6 -ifdisabled accept_rtadv up
		jexec 1 ifconfig lan2 inet6 -ifdisabled accept_rtadv up
		jexec 1 ifconfig lan1 inet 192.168.5.1/24

		ifconfig epair5b vnet 5
		jexec 5 ifconfig epair5b name lan0
		jexec 5 ifconfig lan0 inet6 -ifdisabled accept_rtadv up
		jexec 5 ifconfig lan0 inet 192.168.5.2/24
		jexec 5 route add default 192.168.5.1
		
		ifconfig epair6b vnet 6
		jexec 6 ifconfig epair6b name lan0
		jexec 6 ifconfig lan0 inet6 -ifdisabled accept_rtadv up
		jexec 6 ifconfig lan0 inet 192.168.5.3/24
		jexec 6 route add default 192.168.5.1


		ifconfig bridge0 create up
		ifconfig bridge0 vnet 1
		jexec 1 ifconfig bridge0 addm lan1 addm lan2

		ifconfig epair7a vnet 2
		jexec 2 ifconfig epair7a name lan1
		jexec 2 ifconfig lan1 inet6 -ifdisabled accept_rtadv up
		jexec 2 ifconfig lan1 inet 192.168.7.1/24
 
		ifconfig epair8a vnet 3
		jexec 3 ifconfig epair8a name lan1
		jexec 3 ifconfig lan1 inet6 -ifdisabled accept_rtadv up
		jexec 3 ifconfig lan1 inet 192.168.8.1/24

		ifconfig epair9a vnet 4
		jexec 4 ifconfig epair9a name lan1
		jexec 4 ifconfig lan1 inet6 -ifdisabled accept_rtadv up
		jexec 4 ifconfig lan1 inet 192.168.9.1/24

		ifconfig epair7b vnet 7
		jexec 7 ifconfig epair7b name lan0
		jexec 7 ifconfig lan0 inet6 -ifdisabled accept_rtadv up
		jexec 7 ifconfig lan0 inet 192.168.7.2/24
		jexec 7 route add default 192.168.7.1
		
		ifconfig epair8b vnet 8
		jexec 8 ifconfig epair8b name lan0
		jexec 8 ifconfig lan0 inet6 -ifdisabled accept_rtadv up
		jexec 8 ifconfig lan0 inet 192.168.8.2/24
		jexec 8 route add default 192.168.8.1
		
		ifconfig epair9b vnet 9
		jexec 9 ifconfig epair9b name lan0
		jexec 9 ifconfig lan0 inet6 -ifdisabled accept_rtadv up
		jexec 9 ifconfig lan0 inet 192.168.9.2/24
		jexec 9 route add default 192.168.9.1

