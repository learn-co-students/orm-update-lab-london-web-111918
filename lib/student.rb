require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  require 'pry'

    attr_accessor :id, :name, :grade

    def initialize(name, grade, id = nil)
      @id = id
      @name = name
      @grade = grade
    end

    def self.new_from_db(row)
      new_student = Student.new(row[1], row[2], row[0])
    end

    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
    end

    def self.find_by_name(name)
      sql = <<-SQL
        select * from students where students.name = ?
      SQL
      row = DB[:conn].execute(sql, name)[0]
      self.new_from_db(row)
    end

    def save #self is #<Student:0x007f7fa0268050 @grade="9th", @id=nil, @name="Sarah">
      if self.id
        self.update
      else
        sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        sql = <<-SQL
        SELECT id FROM students ORDER BY id DESC LIMIT 1;
        SQL
        self.id = DB[:conn].execute(sql)[0][0]
      end
    end

    def self.get_highest_id
      sql = <<-SQL
      SELECT id FROM students ORDER BY id DESC LIMIT 1;
      SQL

      DB[:conn].execute(sql)[0]
    end

    def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = "DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
    end

    def update
      sql = <<-SQL
      UPDATE students SET name=? WHERE id=?;
      SQL
      DB[:conn].execute(sql, self.name, self.id)
    end

  end
