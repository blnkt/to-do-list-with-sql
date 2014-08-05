require 'rspec'
require 'task'
require 'pg'
require 'list'

DB = PG.connect({:dbname => 'to_do_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM tasks *;")
  end
end

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lists *;")
  end
end

describe 'Task' do
   it 'is initialized with a name and a list ID' do
    task = Task.new('learn SQL', 1)
    task.should be_an_instance_of Task
  end

  it 'tells you its name' do
    task = Task.new('learn SQL', 1)
    task.name.should eq 'learn SQL'
  end

  it 'tells you its list ID' do
    task = Task.new('learn SQL', 1)
    task.list_id.should eq 1
  end

  it 'starts off with no tasks' do
    Task.all.should eq []
  end

  it 'lets you save tasks to the database' do
    task = Task.new('learn SQL', 1)
    task.save
    Task.all.should eq [task]
  end

  it 'lets you delete a task' do
    task = Task.new 'giggle club social hour', 5
    task.save
    Task.delete('giggle club social hour')
    expect(Task.all).to eq []
  end

  it 'is the same task if it has the same name and ID' do
    task1 = Task.new('learn SQL', 1)
    task2 = Task.new('learn SQL', 1)
    task1.should eq task2
  end

  describe '.all' do
    it "starts off with no tasks" do
      expect(Task.all).to eq []
    end
  end

  describe '.find' do
    it 'retrieves all tasks from its list_id' do
      a_task = Task.new('Brownies', 2)
      a_task.save
      expect(Task.find(2)).to eq [a_task]
    end
  end

end

describe List do
  it 'is initialized with a name' do
    list = List.new({"name" =>'Epicodus stuff'})
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new({"name" =>'Epicodus stuff'})
    list.name.should eq 'Epicodus stuff'
  end

  it 'is the same list if it has the same name' do
    list1 = List.new({"name" =>'Epicodus stuff'})
    list2 = List.new({"name" =>'Epicodus stuff'})
    list1.should eq list2
  end

  it 'sets its id when you save it' do
    list1 = List.new({"name" =>'Epicodus stuff'})
    list1.save
    expect(list1.id).to be_an_instance_of Fixnum
  end

  it 'can be initialized with its database ID' do
    list = List.new({"name" =>'Epicodus stuff', "id" => 1})
    list.should be_an_instance_of List
  end

  describe '.all' do
    it 'returns all lists' do
      list = List.new ({"name" =>'Epicodus stuff'})
      list2 = List.new ({"name" =>'Curry stuff'})
      list.save
      list2.save
      expect(List.all).to eq [list, list2]
    end
  end

  describe '.find' do
    it 'retrieves a list from its id' do
      list = List.new ({"name" =>'Epicodus stuff'})
      list_id = list.save
      expect(List.find(list_id)).to eq list
    end
  end


end
