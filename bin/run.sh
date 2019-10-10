#!/usr/bin/env ruby

require "bundler/setup"

STDOUT.sync = true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "orchestrator"

Orchestrator.listen
