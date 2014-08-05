class Task

  attr_accessor :name, :list_id, :completed, :date

  def initialize (attributes)
    @name = attributes["name"]
    @list_id = attributes["list_id"]
    @completed = attributes["completed"]
    @date = attributes["date"]
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id.to_i == another_task.list_id.to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM tasks;")
    tasks = []
    results.each do |result|
      tasks << Task.new(result)
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id, completed, date) VALUES ('#{@name}', '#{@list_id}', 'f', '#{@date}');")
  end

  def self.find list_id
    results = DB.exec("SELECT * FROM tasks WHERE list_id = '#{list_id}';")
    tasks_found = []
    results.each do |task|
      tasks_found << Task.new(task)
    end
    tasks_found
  end

  def self.mark name
    DB.exec("UPDATE tasks SET completed = true WHERE name = '#{name}';")
  end

  def self.marked list_id
    results = DB.exec("SELECT * FROM tasks WHERE completed = 't' AND list_id = '#{list_id}';")
    tasks = []
    results.each do |result|
      tasks << Task.new(result)
    end
    tasks
  end

  def self.unmarked list_id
    results = DB.exec("SELECT * FROM tasks WHERE completed = 'f' AND list_id = '#{list_id}' ORDER BY date;")
    tasks = []
    results.each do |result|
      tasks << Task.new(result)
    end
    tasks
  end

  # def self.sort_by_date
  #   DB.exec("SELECT * FROM tasks ORDER BY completed = 'f' AND list_id = '#{list_id}';")

  # end

  def self.delete(name)
    DB.exec("DELETE FROM tasks WHERE name = '#{name}';")
  end
end
