# imports
from datetime import datetime
from utilities.logger.creators import getLogger, createLogFile # example functions from package

# set a logging directory 
logs_dir = "logs"
logName = f"testLog_{(datetime.now().strftime('%Y%m%d_%H%M%S'))}"

# create new log file
newLogFile = createLogFile(filepath=logs_dir, filename=logName)

# set a logger
logger = getLogger(logFile=newLogFile, level='INFO', mode='w')
logger.info("-" * 150)
logger.info("This is a simple log file example")

# let's also log an error!
logger.error("I'm logging an ERROR message here")

exit(0) # exit programme 