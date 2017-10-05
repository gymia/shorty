#\ --host 0.0.0.0
require './impraise_api'

use OTR::ActiveRecord::ConnectionManagement
OTR::ActiveRecord.configure_from_hash!(adapter: "sqlite3", host: "localhost", database: "impraise", encoding: "utf8")
run Impraise::API