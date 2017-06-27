""" This file defines the PipelineBenchmarker class

This class is used for timeing the execution of pipelines and
individual methods of blocks inside those pipelines.
"""

import numpy as np
from timeit import default_timer as timer

# This class is for Bifrost
class PipelineBenchmarker(object):
    """ Time total clock and individual parts of blocks in a pipeline """
    def __init__(self):
        """ Set two clock variables for recording """
        self.total_clock_time = 0
        self.relevant_clock_time = 0

    def timeit(self, method):
        """ Decorator for timing execution of a method 
        
        Returns:

            function: the original function, wrapped
                       with a time accumulator
        """
        def timed(*args, **kw):
            ts = timer()
            result = method(*args, **kw)
            te = timer()

            self.relevant_clock_time += te-ts
            return result
        return timed
    
    def reset_times(self):
        """ Set the two class clocks to 0 """
        self.total_clock_time = 0
        self.relevant_clock_time = 0

    def run_benchmark(self):
        """ Run the benchmark once 

        This file should contain the wrapping of a method
        with self.timeit(), e.g., block.on_data = self.timeit(block.on_data),
        which will set the relevant_clock_time to start tracking
        that particular method. Note that you can do this with multiple
        methods, and it will accumulate times for all of them.
        """
        raise NotImplementedError(
                "You need to redefine the run_benchmark class!")

    def average_benchmark(self, number_runs):
        """ Average over a number of tests for more accurate times

        Args:

            number_runs (int): Number of times to run the benchmark,
                               excluding the first time (which runs
                               without recording, as it is always
                               slower)
        
        Returns:

            (clock time, relevant time) - A tuple of the total average
                                          clock time of the pipeline
                                          and the times which were
                                          chosen to be measured inside
                                          run_benchmark
        """

        """ First test is always longer """
        self.run_benchmark()
        self.reset_times()

        total_clock_times = np.zeros(number_runs)
        relevant_clock_times = np.zeros(number_runs)
        for i in range(number_runs):
            self.run_benchmark()
            total_clock_times[i] = self.total_clock_time
            relevant_clock_times[i] = self.relevant_clock_time
            self.reset_times()
        return np.average(total_clock_times), np.average(relevant_clock_times)

# This file does not run!
