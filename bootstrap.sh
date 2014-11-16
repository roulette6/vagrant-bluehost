#!/usr/bin/env bash

echo "--- Installing applications and setting them up ---"

echo "--- Updating packages list ---"
sudo apt-get update > /dev/null 2>&1

echo "--- MySQL options ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties > /dev/null 2>&1
sudo add-apt-repository -y ppa:ondrej/php5-oldstable > /dev/null 2>&1

sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y wget php5 apache2 php5-mcrypt mysql-server-5.5 php5-curl > /dev/null 2>&1

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5-xdebug > /dev/null 2>&1

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_colors=1
xdebug.show_local_vars=1
EOF

# Apache conf
# Apache conf files are in /etc/apache2/

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite > /dev/null 2>&1

echo "--- Setting up document root. Update as needed ---"
sudo rm -rf /var/www > /dev/null 2>&1
sudo ln -fs /vagrant /var/www > /dev/null 2>&1

echo "--- Turn PHP errors on ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "--- Restart apache ---"
sudo service apache2 restart > /dev/null 2>&1

echo "--- Setup complete ---"