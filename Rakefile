# Welcome to the build script for NorthStar Order Entry
# This file is written using rake, the make-like build program written in Ruby.
#
# Don't be scared, it's easier than it looks.
# The Rakefile syntax is documented here:
# https://github.com/jimweirich/rake/blob/master/doc/rakefile.rdoc
#
# Briefly, each task can be run from the command line. For example,
# the command "rake do_something" will run the task that looks like:
#
#   task :do_something do
#     ...
#   end
#
# Some statements that might make your life easier:
#
#   puts "some string"       Writes "some string" to the console
#   sh "cmd arg1 arg2"       Runs "cmd arg1 arg2" from the shell

### MAIN TASKS ###

task :default => [:help]


desc "Same as build:device"
task :build => ["build:device"]


namespace "build" do

  desc "Build a runnable *.app bundle from source"

  task :simulator => [:set_properties] do |t|
    begin_task t
    xcodebuild "archive", @sdk_iphonesimulator
  end



  desc "Build an installable *.ipa file from source"

  task :device => [:set_properties] do |t|
    begin_task t
    xcodebuild "archive", @sdk_iphoneos
  end



  def xcodebuild(action, sdk)
    build_cmd  = "xcodebuild #{action}"
    build_cmd += " -workspace '#{@workspace}'"
    build_cmd += " -scheme '#{@scheme}'"
    build_cmd += " -sdk '#{sdk}'"
    build_cmd += " -configuration Distribution"
    build_cmd += " PRODUCT_NAME='#{@product_name}'" unless @product_name.empty?
    #build_cmd += " PROVISIONING_PROFILE=''"
    #build_cmd += " OTHER_CODE_SIGN_FLAGS='--keychain #{@keychain}'"
    sh build_cmd
  end
end



desc "Same as test:unit"
task :test => ["test:unit"]

namespace "test" do

    desc "Run all automated tests"

    task :ui => [:build, :test] do |t|
      begin_task t

      sh "~/northstar.orderentry.ios/GOPS_Automation/lib/runTests.sh"
    end



    desc "Run all unit tests"

    task :unit => [:build] do |t|
      begin_task t

      status "Wah wah... no unit tests here..."
    end

end



desc "Publish the app to Testflight"

task :testflight => [:build, :test] do |t|
  begin_task t

  fail "Wah wah... Haven't set this up yet..."
end



desc "Publish the app to the Apple App Store"

task :appstore => [:build, :test] do |t|
  begin_task t
  validate_keychain

  fail "Wah wah... Haven't set this up yet..."
end



desc "Clean all build directories"

task :clean => [:set_properties] do |t|
  begin_task t

  sh "xcodebuild -alltargets clean -project '#{@frameworkproj}'"
  sh "xcodebuild -alltargets clean -project '#{@sdkproj}'"

  rm_rf @buildPath
end



### HELPER TASKS ###

task :set_properties do
  @workspace       = "NorthStar Order Entry.xcworkspace"
  @frameworkproj   = "GOPS_Framework/GOPS.xcodeproj"
  @sdkproj         = "GOPS_SDK/GOPS_SDK.xcodeproj"
  @buildPath       = "build"

  @sdk_iphoneos = "iphoneos7.1"
  @sdk_iphonesimulator = "iphonesimulator7.1"
  @scheme = "Order Entry"

  @keychain = ENV['KEYCHAIN'] || "ci_keys"
  @keychain = "#{ENV['HOME']}/Library/Keychains/#{@keychain}.keychain"
  @keychain_password = ENV['KEYCHAIN_PASSWORD'] || "gops"
  @provisioning_profile = ENV['PROVISIONING_PROFILE'] || "CBS Ent"

  @product_name = get_product_name
end


def get_product_name
  if ENV['PRODUCT_NAME']
    ENV['PRODUCT_NAME']
  else

    branch = ENV['BRANCH'] || branch = `basename $(git symbolic-ref HEAD --short)`.strip
    if branch.empty?
      fail "Could not get branch from BRANCH=<val> argument or by executing git"
    end

    branch = File.basename(branch)
    puts "BRANCH: #{branch}"

    if branch == "master"
      "Order Entry"

    elsif branch == "develop"
      "Develop Line"

    elsif branch.match /^release-/
      ver = branch.sub(/release-/, '')
      "Order Entry #{ver}"

    else
      File.basename(branch)
    end
  end
end


task :help do
  puts "Build tasks for the NorthStar Order Entry iOS app"
  puts ""
  system "rake -T"
end


### HELPER METHODS ###

def begin_task(t)
  puts "========================================================================"
  puts " BEGINNING TASK '#{t.name}'"
  puts "========================================================================"
end


def status(txt)
  puts "------------------------------------------------------------------------"
  puts " #{txt}"
  puts "------------------------------------------------------------------------"
end


def validate_keychain
  # Unlock the keychain containing the provisioning profile's private key and set it as the default keychain
  sh "security unlock-keychain -p '#{@keychain_password}' '#{@keychain}'"
  sh "security default-keychain -s '#{@keychain}'"

  # Describe the available provisioning profiles
  puts "Available provisioning profiles"
  puts `security find-identity -p codesigning -v`

  # Verify that the requested provisioning profile can be found
  available_profiles = `security find-certificate -a -c "$provisioning_profile" -Z`
  if available_profiles.match(/^SHA-1/).length == 0
    fail "No provisioning profiles found"
  end
end
