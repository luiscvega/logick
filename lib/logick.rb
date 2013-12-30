class Logick
  def initialize(attrs = {})
    attrs.each do |key, val|
      send(:"#{key}=", val)
    end
  end

  def valid?
    errors.clear
    validate
    errors.empty?
  end

  def errors
    @errors ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def assert(value, error)
    value or errors[error.first].push(error.last) && false
  end

  def self.perform(&block)
    catch(:fail) { Result.new(type: :success, output: block.call) }
  end

  def self.run(atts)
    logick = new(atts)
    logick.failure unless logick.valid?
    logick.run
  end

  def failure
    throw(:fail, Result.new(type: :fail, output: self, errors: errors))
  end

  class Result
    attr_accessor :type, :output, :errors

    def initialize(atts)
      @type   = atts[:type]
      @output = atts[:output]
      @errors = atts[:errors]
    end

    def success?
      @type == :success
    end

    def fail?
      @type == :fail
    end
  end
end
