# Set up Postgres DB locally for development & testing

**Author:** `Dan Collins` <br>

### 1 - Download Postgres & setup super user

Open command line shell <br>

Once inside command line, ensure you remain in your home folder *aka - `~`* <br>
Now: <br>

    # run apt-get update
    apt-get update 

    # once the updates are done, we can install Postgres 
    sudo apt-get install postgresql 

may take a few minutes to download, once it has, it will automatically create a "super user" called `postgres`. We need to give this user a password. Choose any password, when prompted, enter & re-enter it (warning - strokes wont show on screen but are being recorded)

    sudo passwd postgres

enter when prompted 

Once you have done that, actually start the postgres database from your machine <br>
**NOTE** - anytime you have shut the shell this is running in, you *may* need to re-run this start command so that the database is operational for connections

    sudo service postgresql start 

you should get a return to screen saying something like : <br>

> `* Starting PostgreSQL 12 database server` 

With that running, let's actually test connecting into PSQL command line. <br>
We will connect as the `postgres` user. You *may* be prompted to enter the password, but as it's the super user, you *may* not. 

    sudo -u postgres psql

This will open a command line interface that looks like:

    postgres=# 

Here you can type your postgres SQL commands<br>
To exit back to shell, simple use:

    postgres=# \q

With this first section done, let's close the shell.


### 2 - Create a Database & Setup another user

In a new shell, let's ensure we start the database :

    sudo service postgresql start

Let's now create a Database & another user (using the postgres super user)

    sudo -u postgres createdb Rules_Repo

create user:

    sudo -u postgres createuser dms_serv

once that has been done, let's open the SQL command line as super user `postgres`

    sudo -u postgres psql

make the new user a super user also 

    postgres=# ALTER ROLE dms_serv SUPERUSER ;

    postgres=# \q

close the shell.


### 3 - User privieges on Database 

Open shell, start postgres & connect to SQL command line

    sudo service postgresql start 

    sudo -u postgres psql

Let's start by granting a password for our user `dms_serv` <br>
WARNING - don't forget to include the `;` after SQL statements in the command line !!!

    postgres=# ALTER USER dms_serv WITH PASSWORD '<insert password here>' ;

also, grant some privileges to the `Rules_Repo` database 

    postgres=# GRANT ALL PRIVILEGES ON DATABASE "Rules_Repo" TO dms_serv ;

if you want to list databases on this server, you can:

    postgres=# \l 

or show the connection info 

    postgres=# \conninfo 

which will return something like: <br>

> `You are now connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432" 

You can now use an SQL IDE client, like DBeaver, JetBrains DataGrip or even VS Code to JDBC connect to the database! 

typical connection string:

> jdbc:postgresql://localhost:5432/Rules_Repo 

You can replace `localhost` with your machine IP Address if needed as well