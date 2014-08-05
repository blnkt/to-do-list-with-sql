class List

  attr_accessor :name
  attr_reader :id

  def initialize (attributes)
    @name = attributes["name"]
    @id = attributes["id"]
  end

  def ==(another_list)
    self.name = another_list.name
  end

  def self.all
    results = DB.exec("SELECT * FROM lists;")
    lists = []
    results.each do |result|
      lists << List.new(result)
    end
    lists
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
    @id
  end

  def self.find id
    result = DB.exec("SELECT * FROM lists WHERE id = '#{id}';")[0]
    new_list = List.new(result)
    new_list
  end

  def self.delete id
    DB.exec("DELETE FROM lists WHERE id = '#{id}';")
    DB.exec("DELETE FROM tasks WHERE list_id = '#{id}';")
  end
end
