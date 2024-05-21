# Using DBeaver with local postgres

If on a windows machine, you can download the DBeaver SQL client (community edition) for free, from the microsoft store. Assuming you have followed a setup guide `setupLocalPostgres.md` then you will have local hosted postgres on your machine.<br>

You can use the Python script `generateSomeData.py` to create CSV extracts of fake data. Then, use the `setup_dummy_data.sql` file to load that fake data into your postgres once you connect to it via DBeaver.

### Connecting to Postgres from DBeaver

In the client, you can choose `New Database Connection` and select Postgres.<br>

Here, you can specify your details. Remember, if unsure, you can collect these from the Postgresql CLI using the `conninfo` command.<br>

You may also be prompted to download the driver for postgres JDBC, if not already present. <br>

Once that is done, and the connection details are entered, test the connection. Once successful, save the configs, and you now have a connection to your local postgres (providing the server is running of course!!!) from DBeaver, so you can code your SQL away from the command line and use an IDE.

From there, you can open your SQL script (`setup_dummy_data.sql`) and run the commands as needed.