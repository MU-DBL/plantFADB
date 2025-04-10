#!/bin/bash


sed -i 's/^local\s\+all\s\+all\s\+peer/local   all             all                                     md5/' /etc/postgresql/9.3/main/pg_hba.conf

service postgresql restart

export PGPASSWORD='123456'

sudo -u postgres createuser u5g88u3ou5e3bs
sudo -u postgres psql -c "ALTER USER u5g88u3ou5e3bs WITH PASSWORD '${PGPASSWORD}';"
sudo -u postgres psql -c "ALTER USER u5g88u3ou5e3bs CREATEDB;"
sudo -u postgres createdb -O u5g88u3ou5e3bs des9oa54lbpnhb
psql -U u5g88u3ou5e3bs -d des9oa54lbpnhb -f /app/postgres_production-dump.sql