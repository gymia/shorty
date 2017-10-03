require 'rack'
require 'grape'
require './impraise_api'
require 'active_record'
require 'otr-activerecord'
require 'sqlite3'
OTR::ActiveRecord.configure_from_hash!(adapter: "sqlite3", host: "localhost", database: "impraise", encoding: "utf8")
run Impraise::API