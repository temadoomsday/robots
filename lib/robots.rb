# frozen_string_literal: true

require 'open-uri'
require 'uri'
require 'rubygems'
require 'timeout'

class Robots
  DEFAULT_TIMEOUT = 3
  DEFAULT_ROBOTS = "User-agent: *\nAllow: /\n"

  class ParsedRobots
    def initialize(robots_content)
      io = robots_content
      @last_accessed = Time.at(1)
      @other = {}
      @disallows = {}
      @allows = {}
      @delays = {} # added delays to make it work
      agent = /.*/
      io.each do |line|
        next if line =~ /^\s*(#.*|$)/

        arr = line.split(':')
        key = arr.shift
        value = arr.join(':').strip
        value.strip!
        case key
        when 'User-agent'
          agent = to_regex(value)
        when 'Allow'
          @allows[agent] ||= []
          @allows[agent] << to_regex(value)
        when 'Disallow'
          @disallows[agent] ||= []
          @disallows[agent] << to_regex(value)
        when 'Crawl-delay'
          @delays[agent] = value.to_i
        else
          @other[key] ||= []
          @other[key] << value
        end
      end

      @parsed = true
    end

    def allowed?(uri, user_agent)
      return true unless @parsed

      allowed = true
      path = uri.request_uri

      @disallows.each do |key, value|
        next unless user_agent =~ key

        value.each do |rule|
          allowed = false if path =~ rule
        end
      end

      @allows.each do |key, value|
        next if allowed
        next unless user_agent =~ key

        value.each do |rule|
          allowed = true if path =~ rule
        end
      end

      if allowed && @delays[user_agent]
        sleep @delays[user_agent] - (Time.now - @last_accessed)
        @last_accessed = Time.now
      end

      allowed
    end

    def other_values
      @other
    end

    protected

    def to_regex(pattern)
      return /should-not-match-anything-123456789/ if pattern.strip.empty?

      pattern = Regexp.escape(pattern)
      pattern.gsub!(Regexp.escape('*'), '.*')
      Regexp.compile("^#{pattern}")
    end
  end

  def self.get_robots_txt(uri, user_agent)
    Timeout.timeout(Robots.timeout) do
      begin
        URI.join(uri.to_s, '/robots.txt').open('User-Agent' => user_agent)
      rescue StandardError
        nil
      end
    end
  rescue Timeout::Error
    warn 'robots.txt request timed out'
  end

  class << self
    attr_writer :timeout
  end

  def self.timeout
    @timeout || DEFAULT_TIMEOUT
  end

  def initialize(user_agent, custom_robots_txt = nil)
    @user_agent = user_agent
    @custom_robots_txt = custom_robots_txt
    @parsed = {}
  end

  def robots_content(uri)
    return StringIO.new(@custom_robots_txt) if @custom_robots_txt

    io = Robots.get_robots_txt(uri, @user_agent)
    io = StringIO.new(Robots::DEFAULT_ROBOTS) if !io || io.content_type != 'text/plain' || io.status != %w[200 OK]
    io
  end

  def allowed?(uri)
    uri = URI.parse(uri.to_s) unless uri.is_a?(URI)
    host = uri.host
    @parsed[host] ||= ParsedRobots.new(robots_content(uri))
    @parsed[host].allowed?(uri, @user_agent)
  end

  def other_values(uri)
    uri = URI.parse(uri.to_s) unless uri.is_a?(URI)
    host = uri.host
    @parsed[host] ||= ParsedRobots.new(robots_content(uri))
    @parsed[host].other_values
  end
end
