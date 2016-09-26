classdef WorkPool < handle

  properties
    jobs
    pool
  end

  methods

    function obj = WorkPool()
      delete(gcp('nocreate'));
      obj.pool = parpool(1);
    end

    function scheduleJob(obj,job,que)
      if que
        obj.getEndOfQue();
      else
        obj.cancelAll();
      end
      obj.jobs = [parfeval(job,0) obj.jobs];
    end

    function job = getEndOfQue(obj)
      while length(obj.jobs) > 0 && strcmp(obj.jobs(end).State,'finished')
        obj.jobs(end) = [];
      end
      if length(obj.jobs) > 0
        job = obj.jobs(1);
      else
        job = 0;
      end
    end

    function cancelAll(obj)
      for job = obj.jobs
        cancel(job);
      end
      obj.jobs = [];
    end

  end

end
