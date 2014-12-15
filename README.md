# Publigator installed script for clean VPS with CentOS 6

## Prerequisites

First you need a VPS with minimum 512MB RAM and 20GB disk drive with `CentOS 6.x minimal` installed.

Also you should have the domain, ex. yourdomain.com with set DNS records for VPS Hostname and for domain/subdomain for Publigator. So if your domain is yourdomain.com you need to create `A` records in your domains manager:

```
serv.yourdomain.com A 14400 1.2.3.4
publigator.yourdomain.com A 14400 1.2.3.4
```

Where is 1.2.3.4 the IP of your VPS. If you plan to use the dedicated domain for the script, you don’t need to create DNS record for the subdomain.

So if you call `dig serv.yourdomain.com` you should see the IP of your VPS.

## Actions

Next connect to VPS by SSH as `root`. You should be in the home directory of the user (root).

Copy and run next command:

```
curl -O https://raw.githubusercontent.com/jetapps-eu/publigator-vps-installer/master/publigator-install-step1.sh && bash publigator-install-step1.sh
```

The installed will ask you about your e-mail for send you access info for VestaCP control panel, which will be installed.

Also it will ask you about hostname, about domain for Publigator, IP of the VPS, credentials for the DB.

When step-1 will finished, copy next command and run: 

```
curl -O https://raw.githubusercontent.com/jetapps-eu/publigator-vps-installer/master/publigator-install-step2.sh && bash publigator-install-step2.sh
```

When system will ask you some data like paths for components, just press `enter`. You have to wait the actions will be finished.

Next you will see URL and database credentials. Copy it and go to showed URL. You will be able to see Publigator installer system.