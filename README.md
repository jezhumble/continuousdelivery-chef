wp-chef
=======

Bootstrapping:

    apt-get install git
    echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
    sudo mkdir -p /etc/apt/trusted.gpg.d
    gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
    gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null
    apt-get update
    apt-get install opscode-keyring # permanent upgradeable keyring
    echo "chef chef/chef_server_url string none" | debconf-set-selections && apt-get install chef -y
    
Running:

* Check out repository to /var/chef-solo
* Change working directory to /var/chef-solo
* Run chef-solo -c solo.rb -j node.json