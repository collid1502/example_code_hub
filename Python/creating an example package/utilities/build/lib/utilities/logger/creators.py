#----------------------------------------------------------------------------
# Useful utility functions for creating local logging in an app/development
#----------------------------------------------------------------------------

# imports
import os
import logging 


def createLogFile(filepath: str, filename: str) -> object:
    """This function takes a filepath and filename, and then checks if a log file already exists,\
        and if it does not, it will create one: `filepath\\filename.log`\n

    Args:\n
        `filepath (str):` Provide the directory path to where you wish your log file to be created\n
        `filename (str):` Provide the name you wish to give to your log file\n

    Returns:\n
        `object:` returns the filename created with its path\n
    """
    full_path = f"{filepath}/{filename}.log"
    if not os.path.exists(full_path):
        with open(full_path, 'w'):
            pass
    return full_path


def getLogger(logFile: str, level: str = 'INFO', mode: str = 'a') -> object:
    """designed to return a logging object that can be used within your code to log\
        to a designated file\n

    Args:\n
        `logFile (str):` Provide the path to the logfile you wish Logger to be linked to\n
        `level (str, optional):` Provide level you wish logging to be set at. Defaults to 'INFO'\n
        `mode (str, optional):` Mode for how logger should interact with file. Defaults to 'a' for APPEND mode\n

    Returns:\n
        `object:` Returns a `logger` object which can be used to execute logging statements within code\
            and will write those statements to the designated log file\n
    """
    logger = logging.getLogger()
    loggerSet = f"logger.setLevel(logging.{level.upper()})"
    eval(loggerSet) 
    formatter = logging.Formatter('%(asctime)s -- %(levelname)s : %(message)s', "%Y-%m-%d %H:%M:%S")
    file_handler = logging.FileHandler(logFile, mode)
    fileSet = f"file_handler.setLevel(logging.{level.upper()})"
    eval(fileSet) 
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    return logger

