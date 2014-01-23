# encoding: utf-8
# Copyright (c) 2013 Universidade Federal Fluminense (UFF).
# This file is part of SAPOS. Please, consult the license terms in the LICENSE file.

class LevelsController < ApplicationController
  authorize_resource

  helper :advisement_authorizations
  active_scaffold :level do |config|
    config.list.sorting = {:name => 'ASC'}
    columns = [:name, :advisement_authorizations]
    config.columns = columns
    config.create.label = :create_level_label
  end
end 