require_relative "../config/environment.rb"
require_relative "./student.rb"
require 'pry'
jane = Student.new("Jane", "11th")
jane.save
binding.pry

jane_id = jane.id
jane.name = "Jane Smith"
jane.save
jane_from_db = DB[:conn].execute("SELECT * FROM students WHERE id = ?", jane_id)
