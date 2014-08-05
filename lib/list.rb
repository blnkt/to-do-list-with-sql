class List

  attr_accessor :name
  attr_reader :id

  def initialize (name, id = nil)
    @name = name
    @id = id
  end

  def ==(another_list)
    self.name = another_list.name
  end

  def self.all
    results = DB.exec("SELECT * FROM lists;")
    lists = []
    results.each do |result|
      lists << List.new(result['name'])
    end
    tasks
  end

  def save
    results = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id'].to_i
  end


end
