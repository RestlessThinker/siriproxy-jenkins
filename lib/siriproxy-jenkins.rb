require 'rubygems'
require 'jenkins_api_client'
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Jenkins < SiriProxy::Plugin

  def initialize( config = {} )
        @config = config
        @jenkins = JenkinsApi::Client.new( :server_ip =>  @config['jenkins_url'] )
  end

  listen_for /status of job (.+)/i do |jobName|
    if @jenkins.job.exists?( jobName )
      status = @jenkins.job.get_current_build_status( jobName )
      say "The current status on job #{jobName} is: #{status}"
    else
      say "I couldn't find a job with the name #{jobName}"
    end
    request_completed
  end

  listen_for /build job (.+)/i do |jobName|
    if @jenkins.job.exists?( jobName )
      job_id = @jenkins.job.build( jobName, {}, true )
      say "Building job #{jobName} build number is #{job_id}"
    else
      say "I couldn't find a job with the name #{jobName}"
    end
    request_completed
  end
end