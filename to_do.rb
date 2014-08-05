require 'pg'
require './lib/task.rb'

DB = PG.connect({:dbname => 'to_do'})
