# Imports
import requests
from http import HTTPStatus 
import logging 


class API_Extract:
    # Initialise the class with 3 key items, the API Endpoint target, and headers to 
    # pass during requests for authentication, and any query parameters during requests
    def __init__(self, target: str, headers: dict = None, queryParams : dict = None, log: object = None):
        self.target = target # assigns the target URL provided into the instance of the class
        self.headers = headers # same for any headers
        if self.headers != None: # checks that if headers have been passed as an argument, they have been provided as a dictionary
            if isinstance(self.headers, dict) == False:
                raise ValueError(f"You have provided headers that are not in a dictionary object {API_Extract.__name__}. Please submit as a dictionary") 
        self.queryParams = queryParams 
        if self.queryParams != None: # checks that if query params have been passed as an argument, they have been provided as a dictionary
            if isinstance(self.queryParams, dict) == False:
                raise ValueError(f"You have provided query parameters that are not in a dictionary object {API_Extract.__name__}. Please submit as a dictionary")
        if log == None:
            self.log = logging.getLogger()
        else:
            self.log = log 
        # create connection Session
        self.re = requests.Session()


    def closeSession(self, Session: object = None):
        """ Closes the Requests.Session() object passed to it, or the one instantiated by the class object"""
        try:
            if Session != None:
                Session.close()
            else:
                (self.re).close() 
            self.log.info("Closed Requests Session()")
        except Exception as e:
            self.log.error(e)
            raise e 
        

    # create a method for pinging ang API to check you can authenticate against it and access data
    def check_api_endpoint(self) -> object:
        """Uses the requests.head() function to check whether the api endpoint can be reached

        Args:
            self.target (str): The URL you wish to target the check at 
            self.headers (dict): A dictionary object containing headers details for the API request

        Returns:
            obj: Returns the connection object from the API endpoint ping
        """
        # assuming headers check pass, run the ping 
        self.log.info("Pinging API endpoint")
        ping = ((self.re).head(
            url=self.target,
            headers=self.headers,
            timeout=60 # cap to 1 minutes for a response
        ))
        return ping
    

    # create a method for actually pulling the response back from said API (in JSON) 
    def collect_api_response(self, target: str, headers: dict = None, queryParams: dict = None) -> object:
        """Uses the requests.get() function to collect response from API endpoint

        Returns:
            object: Returns the response from the API endpoint
        """
        if headers != None: # checks that if headers have been passed as an argument, they have been provided as a dictionary
            if isinstance(headers, dict) == False:
                raise ValueError(f"You have provided headers that are not in a dictionary object in {self.collect_api_response.__name__}. Please submit as a dictionary") 
        if queryParams != None: # checks that if query params have been passed as an argument, they have been provided as a dictionary
            if isinstance(queryParams, dict) == False:
                raise ValueError(f"You have provided query parameters that are not in a dictionary object in {self.collect_api_response.__name__}. Please submit as a dictionary")
        self.log.info(f"Requesting API response from target:\n\t{target}")
        api_req = ((self.re).get(
            url=target, # target endpoint
            headers=headers, # headers to authorise request
            params=queryParams, # params to send in request body 
            timeout=300 # 5 minute timeout (300 seconds) 
        )) # initiates request
        return api_req.json() # returns the response as JSON
    

    # create a function that can load data from **ALL** pages of response data, when multiple pages exist in the response
    def load_all_pages(self) -> list:
        """Takes an API response, contained over multiple pages, and issues the requests, appending the data into one list
           of responses, so that it can eventually be converted into a dataframe.


        Returns:
            list: Returns a list of dictionaries, which are the JSON responses of the API extract stacked together 
        """
        # check API endpoint is accessible first. If not, raise an Exception to stop the process
        self.log.info(f"Send test to API endpoint") 
        api_available = self.check_api_endpoint()
        if api_available.status_code != HTTPStatus.OK:
            self.log.error(f"Unsuccessful test to API endpoint. Resulting status code: {api_available.status_code}")
            raise Exception(f"API is unavailble for {self.target}.\nResponse Status Code: {api_available.status_code}")
        # use the `collect_api_response()` method to pull the initial metadata based on Class level API target, headers & Query params
        self.log.info("Ping test complete. Run data extraction request ...")
        try:
            initial_response = self.collect_api_response(
                target=self.target,
                headers=self.headers,
                queryParams=self.queryParams 
            ) 
            #meta = initial_response['meta'] # this details pages, path, total etc.
            links = initial_response['links'] # this details the individual path, as well as previous & next paths if they exist 
            response_data = initial_response['data'] # Thie first batch of response data
            if links['next'] != None: # This means more pages exist which need to be pulled
                next_api_hit = links['next'] 
                page_counter = 1
                while next_api_hit != None: # now, process a loop until `next_api_hit` is Null an there are no more pages to request data from
                    next_response = self.collect_api_response(
                        target=next_api_hit, headers=self.headers, queryParams=self.queryParams
                    )
                    # extend the data into the `response_data` object 
                    response_data.extend(next_response['data'])
                    # now overwrite the value of `next_api_hit` with the `next` key-value from the `links` key in the API response
                    next_api_hit = next_response['links']['next'] # When no pages are left, this will set to `None` & break the while loop
                    page_counter += 1
                    self.log.info(f"Extracting responses from page {page_counter} ...") 
        except Exception as e:
            self.log.error(e)
            raise e
        # we now have all our data appended into a list object, containing dictionaries (aka. rows of info)
        # so we can return that list object 
        return response_data 
