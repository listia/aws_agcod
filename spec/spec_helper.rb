require "pathname"
require "http"

ROOT_PATH = Pathname.new(__FILE__).join("../..").expand_path
$LOAD_PATH.unshift(ROOT_PATH.join("lib"))

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Disable the should syntax compeletely; we use the expect syntax only.
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
