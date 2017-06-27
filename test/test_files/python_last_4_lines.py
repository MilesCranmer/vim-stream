            total_clock_times[i] = self.total_clock_time
            relevant_clock_times[i] = self.relevant_clock_time
            self.reset_times()
        return np.average(total_clock_times), np.average(relevant_clock_times)
