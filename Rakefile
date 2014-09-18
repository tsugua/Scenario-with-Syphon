# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require "bundler"
  Bundler.require
rescue LoadError
end
require 'bubble-wrap/all'


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Scenario-Syphon'
  app.frameworks += %W[OpenGL SceneKit ApplicationServices QuartzCore CoreGraphics GLKit]
  app.embedded_frameworks << "vendor/Syphon.framework"
  app.vendor_project("vendor/ServerEOS", :xcode, :target => "ServerEOS", :products => ["libServerEOS.a"])
  app.bridgesupport_files << "vendor/ServerEOS/ServerEOS/BridgeSupport.bridgesupport"
  
  app.vendor_project('./vendor/ImageCapture', :static)
  
end
