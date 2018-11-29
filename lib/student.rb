require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id


    def initialize(id=nil, name, grade)
      @name = name
      @grade = grade
      @id = id
    end

    def self.new_from_db(row)
      # create a new Student object given a row from the database
      id = row[0]
      name = row[1]
      grade = row[2]
      new_student = self.new(id, name, grade)
    end

    def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
      DROP TABLE students
      SQL
      DB[:conn].execute(sql)
    end

    def save
      if self.id
        self.update
      else
        sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
      end


      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
      student
    end

    def self.find_by_name(name)
      # find the student in the database given a name
      # return a new instance of the Student class
      sql = "SELECT * FROM students WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Student.new(result[0], result[1], result[2])
    end



    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = #{self.id}"
        DB[:conn].execute(sql, self.name, self.grade)
    end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
end
