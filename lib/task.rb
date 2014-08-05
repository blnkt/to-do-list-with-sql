class Task

  attr_accessor :name, :list_id

  def initialize (name, list_id)
    @name = name
    @list_id = list_id
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id.to_i == another_task.list_id.to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM tasks;")
    tasks = []
    results.each do |result|
      tasks << Task.new(result['name'], result['list_id'])
    end
    tasks
  end

  def save
    DB.exec("INSERT INTO tasks (name, list_id) VALUES ('#{@name}', '#{@list_id}');")
  end

  def self.find list_id
    results = DB.exec("SELECT * FROM tasks WHERE list_id = '#{list_id}';")
    tasks_found = []
    results.each do |task|
      tasks_found << Task.new(task['name'], task['list_id'])
    end
    tasks_found
  end

  def self.delete(name)
    DB.exec("DELETE FROM tasks WHERE name = '#{name}';")
  end

end
