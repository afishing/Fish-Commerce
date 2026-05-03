@echo off
mysql -u root --password=wsp0222. --default-character-set=utf8mb4 < "%~dp0data_address_all_users.sql"
echo Done.
