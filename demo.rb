#!/usr/bin/env ruby

require_relative 'shadow_package'
require_relative 'shadow_prototype'

ShadowSolution::Package.set("com.acitve.passport")

ShadowSolution::Prototype.using(ShadowSolution::MVP)

ShadowSolution::Prototype.create_screen("login")
