require 'rubygems'
require  'jenkins-remote-api'

class SiriProxy::Plugin::Jenkins < SiriProxy::Plugin
  def initialize( config = {} )	
  	@config = config
  	@jenkins = Ci::Jenkins.new( @config['jenkins_url'] )
  end

  listen_for /what is the status of job (.+)/i do |jobName|
  	jobs = jenkins.list_all_job_names
  	if jobs.include?( jobName )
	  	status = jenkins.current_status_on_job( jobName )
	  	say "The current status on job #{jobName} is: "
  	else
  		say "I'm sorry, I couldn't find the job #{jobName}"
  	end

  	request_completed
  end
end