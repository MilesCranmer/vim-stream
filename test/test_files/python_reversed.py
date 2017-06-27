        return np.average(total_clock_times), np.average(relevant_clock_times)
            self.reset_times()
            relevant_clock_times[i] = self.relevant_clock_time
            total_clock_times[i] = self.total_clock_time
            self.run_benchmark()
        for i in range(number_runs):
        relevant_clock_times = np.zeros(number_runs)
        total_clock_times = np.zeros(number_runs)

        self.reset_times()
        self.run_benchmark()
        """ First test is always longer """

        """
                                          run_benchmark
                                          chosen to be measured inside
                                          and the times which were
                                          clock time of the pipeline
            (clock time, relevant time) - A tuple of the total average

        Returns:
        
                               slower)
                               without recording, as it is always
                               excluding the first time (which runs
            number_runs (int): Number of times to run the benchmark,

        Args:

        """ Average over a number of tests for more accurate times
    def average_benchmark(self, number_runs):

                "You need to redefine the run_benchmark class!")
        raise NotImplementedError(
        """
        methods, and it will accumulate times for all of them.
        that particular method. Note that you can do this with multiple
        which will set the relevant_clock_time to start tracking
        with self.timeit(), e.g., block.on_data = self.timeit(block.on_data),
        This file should contain the wrapping of a method

        """ Run the benchmark once 
    def run_benchmark(self):

        self.relevant_clock_time = 0
        self.total_clock_time = 0
        """ Set the two class clocks to 0 """
    def reset_times(self):
    
        return timed
            return result
            self.relevant_clock_time += te-ts

            te = timer()
            result = method(*args, **kw)
            ts = timer()
        def timed(*args, **kw):
        """
                       with a time accumulator
            function: the original function, wrapped

        Returns:
        
        """ Decorator for timing execution of a method 
    def timeit(self, method):

        self.relevant_clock_time = 0
        self.total_clock_time = 0
        """ Set two clock variables for recording """
    def __init__(self):
    """ Time total clock and individual parts of blocks in a pipeline """
class PipelineBenchmarker(object):

from timeit import default_timer as timer
import numpy as np

"""
individual methods of blocks inside those pipelines.
This class is used for timeing the execution of pipelines and

""" This file defines the PipelineBenchmarker class
