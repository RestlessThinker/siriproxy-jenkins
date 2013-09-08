require 'rubygems'
require 'jenkins-remote-api'
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Jenkins < SiriProxy::Plugin
  def initialize( config = {} )	
  	@config = config
  	@jenkins = Ci::Jenkins.new( @config['jenkins_url'] )
  end

  listen_for /status of job (.+)/i do |jobName|
  	jobs = @jenkins.list_all_job_names
  	if jobs.include?( jobName )
	  	status = @jenkins.current_status_on_job( jobName )
	  	say "The current status on job #{jobName} is: "
  	else
  		say "I'm sorry, I couldn't find the job #{jobName}"
  	end

  	request_completed
  end
end