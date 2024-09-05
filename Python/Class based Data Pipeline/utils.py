# create some helpful utils that other modules / scripts can call upon 

# Imports 
import sys 
import logging 


# create a function that returns a logging object to be used in pipeline
def logger(output: str = 'terminal', level: str = 'INFO', filename: str = None) -> object:
    """Creates & returns a logging object.

    Args:
        output (str, optional): choose terminal or file as to where to direct log messages to. Defaults to 'terminal'.
        level (str, optional): choose logging level. Defaults to 'INFO'.
        filename (str, optional): if writing logs to file, provide the filepath.log. Defaults to None.

    Returns:
        object: a logging object that can be called throughout a script
    """
    # configure logging 
    logger = logging.getLogger() 
    eval(f"logger.setLevel(logging.{level})") # evaluates logging level provided & sets it
    # determine whether to log to terminal or file 
    if output != "terminal" and output != "file":
        raise ValueError(f"Please specify a value of 'terminal' or 'file' for the output argument in {logger.__name__}")
    elif output == "file":
        if filename == None:
            raise ValueError(f"You have specified file logging, but provided no filename argument. Please provide `filename` path in {logger.__name__}")
        else:
            handler = logging.FileHandler(filename, mode='a') # sets to append for logging to given file name
    else:
        handler = logging.StreamHandler(stream=sys.stdout) 
    # set formatting for logs 
    formatter = logging.Formatter("%(asctime)s -- %(levelname)s : %(message)s") 
    handler.setFormatter(formatter)
    logger.addHandler(handler) 
    return logger 