# Okofony
Okofen management interface on Symfony

Provide an easy way to install Okofen on your local network to monitor OKofen Pellematic Touch Boiler

# How to install

Make sure you have docker install on your server, then run that command :
```shell
docker compose up -d
```

# Dev mode

Make sure you have docker and make install on you machine, then run 
```shell
make start
```

Add this lines in your `/etc/hosts` :
```
127.0.0.1 www.okofony.test okofony.test legacy.okofony.test
```

You can access the legacy site here : legacy.okofony.test:{PORT}
And access the new site here : www.okofony.test:{PORT}
