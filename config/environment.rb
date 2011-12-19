# -*- encoding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
require 'encoding_patch'
require 'will_paginate'
#require 'fastercsv'
# Initialize the rails application
Shopping::Application.initialize!
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '&lt 前へ'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '次へ &gt'
